#ifndef DATABASE_H
#define DATABASE_H

#include <mysql.h>
#include <string>

using namespace std;

const char* HOST = "localhost";
const char* USER = "root";
const char* PASS = "1234";
const char* DB   = "project2";
const unsigned int PORT = 3306;

MYSQL* connect_db();

void executeSalesTrendsQuery(MYSQL* conn);
void executeDefectivePartTrackingQuery(MYSQL* conn);
void executeTopBrandsRevenueQuery(MYSQL* conn);
void executeTopBrandsSalesQuery(MYSQL* conn);
void executeSeasonalSalesQuery(MYSQL* conn);
void executeInventoryEfficiencyQuery(MYSQL* conn);
void executeSupplierCoverageQuery(MYSQL* conn);

#endif