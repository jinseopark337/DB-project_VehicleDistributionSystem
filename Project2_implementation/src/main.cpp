#define NOMINMAX        // [수정] 표준 numeric_limits::max 함수와 Windows API 간의 매크로 충돌 차단
#include <mysql.h>
#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <cstring>
#include <limits>

using namespace std;

const char* HOST = "localhost";
const char* USER = "root";
const char* PASS = "1234";
const char* DB   = "project2";
const unsigned int PORT = 3306;

void print_mysql_error(MYSQL* conn, const string& context) {
    cerr << "[MYSQL ERROR] " << context << "\n";
    cerr << "Error: " << mysql_error(conn) << "\n\n";
}

void print_stmt_error(MYSQL_STMT* stmt, const string& context) {
    cerr << "[MYSQL STMT ERROR] " << context << "\n";
    cerr << "Error: " << mysql_stmt_error(stmt) << "\n\n";
}

MYSQL* connect_db() {
    MYSQL* conn = mysql_init(nullptr);

    if (conn == nullptr) {
        cerr << "[FATAL] mysql_init() failed.\n";
        return nullptr;
    }

    mysql_options(conn, MYSQL_SET_CHARSET_NAME, "utf8mb4");

    if (!mysql_real_connect(conn, HOST, USER, PASS, DB, PORT, nullptr, 0)) {
        print_mysql_error(conn, "Database connection failed");
        mysql_close(conn);
        return nullptr;
    }

    cout << "[SUCCESS] Connected to MySQL database using MySQL C API.\n\n";
    return conn;
}

void execute_static_report(MYSQL* conn, const string& query, const string& title) {
    if (mysql_query(conn, query.c_str()) != 0) {
        print_mysql_error(conn, title + " execution failed");
        return;
    }

    MYSQL_RES* result = mysql_store_result(conn);

    if (result == nullptr) {
        if (mysql_field_count(conn) == 0) {
            cout << "[SUCCESS] Query executed. Affected rows: "
                 << mysql_affected_rows(conn) << "\n";
        } else {
            print_mysql_error(conn, title + " result fetch failed");
        }
        return;
    }

    int num_fields = mysql_num_fields(result);
    MYSQL_FIELD* fields = mysql_fetch_fields(result);

    cout << "\n=========================================================================================================\n";
    cout << " [" << title << "]\n";
    cout << "=========================================================================================================\n";

    for (int i = 0; i < num_fields; i++) {
        cout << left << setw(20) << fields[i].name << " ";
    }

    cout << "\n---------------------------------------------------------------------------------------------------------\n";

    MYSQL_ROW row;
    int row_count = 0;

    while ((row = mysql_fetch_row(result))) {
        unsigned long* lengths = mysql_fetch_lengths(result);

        for (int i = 0; i < num_fields; i++) {
            string value = row[i] ? string(row[i], lengths[i]) : "NULL";

            if (value.length() > 19) {
                value = value.substr(0, 16) + "...";
            }

            cout << left << setw(20) << value << " ";
        }

        cout << "\n";
        row_count++;
    }

    if (row_count == 0) {
        cout << "[INFO] Query executed successfully, but no matching records found.\n";
    }

    cout << "=========================================================================================================\n\n";

    mysql_free_result(result);
}

void execute_prepared_report(
    MYSQL* conn,
    const string& query,
    const vector<string>& params,
    const string& title
) {
    MYSQL_STMT* stmt = mysql_stmt_init(conn);

    if (stmt == nullptr) {
        cerr << "[FATAL] mysql_stmt_init() failed.\n";
        return;
    }

    if (mysql_stmt_prepare(stmt, query.c_str(), query.length()) != 0) {
        print_stmt_error(stmt, title + " prepare failed");
        mysql_stmt_close(stmt);
        return;
    }

    vector<MYSQL_BIND> param_binds(params.size());
    vector<unsigned long> param_lengths(params.size());

    memset(param_binds.data(), 0, sizeof(MYSQL_BIND) * param_binds.size());

    for (size_t i = 0; i < params.size(); i++) {
        param_lengths[i] = static_cast<unsigned long>(params[i].length());

        param_binds[i].buffer_type = MYSQL_TYPE_STRING;
        param_binds[i].buffer = (void*)params[i].c_str();
        param_binds[i].buffer_length = param_lengths[i];
        param_binds[i].length = &param_lengths[i];
    }

    if (!params.empty()) {
        if (mysql_stmt_bind_param(stmt, param_binds.data()) != 0) {
            print_stmt_error(stmt, title + " bind parameter failed");
            mysql_stmt_close(stmt);
            return;
        }
    }

    if (mysql_stmt_execute(stmt) != 0) {
        print_stmt_error(stmt, title + " execute failed");
        mysql_stmt_close(stmt);
        return;
    }

    MYSQL_RES* metadata = mysql_stmt_result_metadata(stmt);

    if (metadata == nullptr) {
        print_stmt_error(stmt, title + " metadata fetch failed");
        mysql_stmt_close(stmt);
        return;
    }

    int num_fields = mysql_num_fields(metadata);
    MYSQL_FIELD* fields = mysql_fetch_fields(metadata);

    vector<MYSQL_BIND> result_binds(num_fields);
    vector<vector<char>> buffers(num_fields, vector<char>(256));
    vector<unsigned long> lengths(num_fields);
    vector<char> is_null(num_fields);
    vector<char> errors(num_fields);

    memset(result_binds.data(), 0, sizeof(MYSQL_BIND) * result_binds.size());

    for (int i = 0; i < num_fields; i++) {
        result_binds[i].buffer_type = MYSQL_TYPE_STRING;
        result_binds[i].buffer = buffers[i].data();
        result_binds[i].buffer_length = buffers[i].size();
        result_binds[i].length = &lengths[i];
        
        result_binds[i].is_null = reinterpret_cast<bool*>(&is_null[i]);
        result_binds[i].error = reinterpret_cast<bool*>(&errors[i]);
    }

    if (mysql_stmt_bind_result(stmt, result_binds.data()) != 0) {
        print_stmt_error(stmt, title + " bind result failed");
        mysql_free_result(metadata);
        mysql_stmt_close(stmt);
        return;
    }

    if (mysql_stmt_store_result(stmt) != 0) {
        print_stmt_error(stmt, title + " store result failed");
        mysql_free_result(metadata);
        mysql_stmt_close(stmt);
        return;
    }

    cout << "\n=========================================================================================================\n";
    cout << " [" << title << "]\n";
    cout << "=========================================================================================================\n";

    for (int i = 0; i < num_fields; i++) {
        cout << left << setw(20) << fields[i].name << " ";
    }

    cout << "\n---------------------------------------------------------------------------------------------------------\n";

    int row_count = 0;

    while (true) {
        int status = mysql_stmt_fetch(stmt);

        if (status == MYSQL_NO_DATA) break;

        if (status == 1) {
            print_stmt_error(stmt, title + " fetch failed");
            break;
        }

        for (int i = 0; i < num_fields; i++) {
            string value;

            if (is_null[i]) {
                value = "NULL";
            } else {
                value = string(buffers[i].data(), lengths[i]);

                if (value.length() > 19) {
                    value = value.substr(0, 16) + "...";
                }
            }

            cout << left << setw(20) << value << " ";
        }

        cout << "\n";
        row_count++;
    }

    if (row_count == 0) {
        cout << "[INFO] Query executed successfully, but no matching records found.\n";
    }

    cout << "=========================================================================================================\n\n";

    mysql_free_result(metadata);
    mysql_stmt_free_result(stmt);
    mysql_stmt_close(stmt);
}

void executeSalesTrendsQuery(MYSQL* conn) {
    string query =
        "SELECT "
        "YEAR(S.date) AS Sales_Year, "
        "MONTH(S.date) AS Sales_Month, "
        "WEEK(S.date) AS Sales_Week, "
        "B.name AS Brand_Name, "
        "C.gender AS Buyer_Gender, "
        "CASE "
        "WHEN C.annual_income < 50000 THEN 'Under $50k' "
        "WHEN C.annual_income >= 50000 AND C.annual_income < 100000 THEN '$50k-$100k' "
        "WHEN C.annual_income >= 100000 AND C.annual_income <= 200000 THEN '$100k-$200k' "
        "ELSE 'Over $200k' "
        "END AS Income_Range, "
        "COUNT(S.sale_id) AS Units_Sold, "
        "SUM(S.sale_price) AS Total_Revenue "
        "FROM Sales S "
        "JOIN Vehicles V ON S.vin = V.vin "
        "JOIN Models M ON V.model_id = M.model_id "
        "JOIN Brands B ON M.brand_id = B.brand_id "
        "JOIN Customers C ON S.customer_id = C.customer_id "
        "WHERE S.date >= DATE_SUB('2026-06-01', INTERVAL 3 YEAR) "
        "GROUP BY YEAR(S.date), MONTH(S.date), WEEK(S.date), B.name, C.gender, Income_Range "
        "ORDER BY Sales_Year DESC, Sales_Month DESC, Sales_Week DESC, Total_Revenue DESC;";

    execute_static_report(conn, query, "Q1: Sales Trends");
}

void executeDefectivePartTrackingQuery(MYSQL* conn) {
    string supplier_name;
    string part_type;
    string start_date;
    string end_date;

    // [수정] NOMINMAX 이식에 따라 의존성을 제거하고 1바이트 엔터 잔여 버퍼 클리어 처리로 최적화
    cin.ignore(1, '\n');

    cout << "\nSupplier name ex) Getrag: ";
    getline(cin, supplier_name);

    cout << "Part type ex) transmission: ";
    getline(cin, part_type);

    cout << "Supply start date YYYY-MM-DD: ";
    getline(cin, start_date);

    cout << "Supply end date YYYY-MM-DD: ";
    getline(cin, end_date);

    string query =
        "SELECT "
        "V.vin AS Affected_VIN, "
        "M.model_name AS Model_Name, "
        "IFNULL(C.name, 'UNSOLD') AS Customer_Name, "
        "IFNULL(C.phone, 'N/A') AS Customer_Phone, "
        "IFNULL(CAST(S.date AS CHAR), 'N/A') AS Purchase_Date, "
        "SC.part_type AS Part_Type, "
        "Sup.name AS Supplier_Name "
        "FROM Supply_Contracts SC "
        "JOIN Models M ON SC.model_id = M.model_id "
        "JOIN Vehicles V ON SC.model_id = V.model_id AND SC.plant_id = V.plant_id "
        "JOIN Suppliers Sup ON SC.supplier_id = Sup.supplier_id "
        "LEFT JOIN Sales S ON V.vin = S.vin "
        "LEFT JOIN Customers C ON S.customer_id = C.customer_id "
        "WHERE Sup.name = ? "
        "AND SC.part_type = ? "
        "AND SC.supply_date BETWEEN ? AND ? "
        "AND V.manufacturing_date >= SC.supply_date;";

    vector<string> params = {
        supplier_name,
        part_type,
        start_date,
        end_date
    };

    execute_prepared_report(conn, query, params, "Q2: Defective Part Tracking");
}

void executeTopBrandsRevenueQuery(MYSQL* conn) {
    string query =
        "SELECT "
        "B1.name AS Brand_Name, "
        "SUM(S1.sale_price) AS Total_Revenue "
        "FROM Sales S1 "
        "JOIN Vehicles V1 ON S1.vin = V1.vin "
        "JOIN Models M1 ON V1.model_id = M1.model_id "
        "JOIN Brands B1 ON M1.brand_id = B1.brand_id "
        "WHERE S1.date BETWEEN '2025-06-01' AND '2026-06-01' "
        "GROUP BY B1.brand_id, B1.name "
        "HAVING ( "
        "SELECT COUNT(*) "
        "FROM ( "
        "SELECT M2.brand_id, SUM(S2.sale_price) AS Brand_Revenue "
        "FROM Sales S2 "
        "JOIN Vehicles V2 ON S2.vin = V2.vin "
        "JOIN Models M2 ON V2.model_id = M2.model_id "
        "WHERE S2.date BETWEEN '2025-06-01' AND '2026-06-01' "
        "GROUP BY M2.brand_id "
        ") AS Revenue_Ranking "
        "WHERE Revenue_Ranking.Brand_Revenue > SUM(S1.sale_price) "
        ") < 2 "
        "ORDER BY Total_Revenue DESC;";

    execute_static_report(conn, query, "Q3: Top Brands by Revenue");
}

void executeTopBrandsSalesQuery(MYSQL* conn) {
    string query =
        "SELECT "
        "B1.name AS Brand_Name, "
        "COUNT(S1.sale_id) AS Total_Units_Sold "
        "FROM Sales S1 "
        "JOIN Vehicles V1 ON S1.vin = V1.vin "
        "JOIN Models M1 ON V1.model_id = M1.model_id "
        "JOIN Brands B1 ON M1.brand_id = B1.brand_id "
        "WHERE S1.date BETWEEN '2025-06-01' AND '2026-06-01' "
        "GROUP BY B1.brand_id, B1.name "
        "HAVING ( "
        "SELECT COUNT(*) "
        "FROM ( "
        "SELECT M2.brand_id, COUNT(S2.sale_id) AS Brand_Units "
        "FROM Sales S2 "
        "JOIN Vehicles V2 ON S2.vin = V2.vin "
        "JOIN Models M2 ON V2.model_id = M2.model_id "
        "WHERE S2.date BETWEEN '2025-06-01' AND '2026-06-01' "
        "GROUP BY M2.brand_id "
        ") AS Unit_Ranking "
        "WHERE Unit_Ranking.Brand_Units > COUNT(S1.sale_id) "
        ") < 2 "
        "ORDER BY Total_Units_Sold DESC;";

    execute_static_report(conn, query, "Q4: Top Brands by Unit Sales");
}

// Q5: ONLY_FULL_GROUP_BY 무결성 에러 보완 패치 완료
void executeSeasonalSalesQuery(MYSQL* conn) {
    string body_style;

    // [수정] numeric_limits 의존성을 완전히 지우고 엔터키 버퍼만 저격 제거
    cin.ignore(1, '\n');

    cout << "\nBody style ex) convertible, SUV, sedan: ";
    getline(cin, body_style);

    // ★ [크리티컬 패치 완료]: ONLY_FULL_GROUP_BY 우회를 위해 CAST형 형변환을 제거하고 온전한 비집계 명세 칼럼 매핑
    string query =
        "SELECT "
        "M1.body_style AS Body_Style, "
        "MONTH(S1.date) AS Best_Month, "
        "COUNT(S1.sale_id) AS Units_Sold "
        "FROM Sales S1 "
        "JOIN Vehicles V1 ON S1.vin = V1.vin "
        "JOIN Models M1 ON V1.model_id = M1.model_id "
        "WHERE M1.body_style = ? "
        "GROUP BY M1.body_style, MONTH(S1.date) " // SELECT 절과 매칭 완료
        "HAVING COUNT(S1.sale_id) = ( "
        "SELECT MAX(Sub.Monthly_Count) "
        "FROM ( "
        "SELECT COUNT(S2.sale_id) AS Monthly_Count "
        "FROM Sales S2 "
        "JOIN Vehicles V2 ON S2.vin = V2.vin "
        "JOIN Models M2 ON V2.model_id = M2.model_id "
        "WHERE M2.body_style = ? "
        "GROUP BY MONTH(S2.date) "
        ") AS Sub "
        ") "
        "ORDER BY MONTH(S1.date) ASC;";

    vector<string> params = {
        body_style,
        body_style
    };

    execute_prepared_report(conn, query, params, "Q5: Seasonal Sales Patterns");
}

void executeInventoryEfficiencyQuery(MYSQL* conn) {
    string query =
        "SELECT "
        "D.dealer_id AS Dealer_ID, "
        "D.name AS Dealer_Name, "
        "ROUND(AVG(DATEDIFF(S.date, V.manufacturing_date)), 1) AS Avg_Days_In_Inventory "
        "FROM Sales S "
        "JOIN Vehicles V ON S.vin = V.vin "
        "JOIN Dealers D ON S.dealer_id = D.dealer_id "
        "GROUP BY D.dealer_id, D.name "
        "ORDER BY Avg_Days_In_Inventory DESC;";

    execute_static_report(conn, query, "Q6: Dealer Inventory Efficiency");
}

void executeSupplierCoverageQuery(MYSQL* conn) {
    string query =
        "SELECT "
        "Sup1.supplier_id AS Supplier_ID, "
        "Sup1.name AS Supplier_Name, "
        "COUNT(DISTINCT SC1.model_id) AS Supported_Models_Count "
        "FROM Supply_Contracts SC1 "
        "JOIN Suppliers Sup1 ON SC1.supplier_id = Sup1.supplier_id "
        "GROUP BY Sup1.supplier_id, Sup1.name "
        "HAVING COUNT(DISTINCT SC1.model_id) = ( "
        "SELECT MAX(Sub.Model_Count) "
        "FROM ( "
        "SELECT COUNT(DISTINCT SC2.model_id) AS Model_Count "
        "FROM Supply_Contracts SC2 "
        "GROUP BY SC2.supplier_id "
        ") AS Sub "
        ");";

    execute_static_report(conn, query, "Q7: Supplier Coverage");
}

void display_menu() {
    cout << "===== Project 2 MySQL C API Menu =====\n";
    cout << "1. Q1 Sales Trends\n";
    cout << "2. Q2 Defective Part Tracking\n";
    cout << "3. Q3 Top Brands by Revenue\n";
    cout << "4. Q4 Top Brands by Unit Sales\n";
    cout << "5. Q5 Seasonal Sales Patterns\n";
    cout << "6. Q6 Dealer Inventory Efficiency\n";
    cout << "7. Q7 Supplier Coverage\n";
    cout << "0. Exit\n";
    cout << "=====================================\n";
    cout << "Enter choice: ";
}

int main() {
    if (mysql_library_init(0, nullptr, nullptr)) {
        cerr << "[FATAL] Could not initialize MySQL client library.\n";
        return 1;
    }

    MYSQL* conn = connect_db();

    if (conn == nullptr) {
        mysql_library_end();
        return 1;
    }

    while (true) {
        display_menu();

        int choice;

        if (!(cin >> choice)) {
            cout << "\n[INPUT ERROR] Please enter a number.\n\n";
            cin.clear();
            cin.ignore(1, '\n');
            continue;
        }

        cout << "\n";

        switch (choice) {
            case 1:
                executeSalesTrendsQuery(conn);
                break;

            case 2:
                executeDefectivePartTrackingQuery(conn);
                break;

            case 3:
                executeTopBrandsRevenueQuery(conn);
                break;

            case 4:
                executeTopBrandsSalesQuery(conn);
                break;

            case 5:
                executeSeasonalSalesQuery(conn);
                break;

            case 6:
                executeInventoryEfficiencyQuery(conn);
                break;

            case 7:
                executeSupplierCoverageQuery(conn);
                break;

            case 0:
                cout << "[EXIT] Program terminated safely.\n";
                mysql_close(conn);
                mysql_library_end();
                return 0;

            default:
                cout << "[INPUT ERROR] Please select 0 to 7.\n\n";
                break;
        }
    }
}