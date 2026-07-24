# Project 2: Vehicle Distribution and Assembly System Control Console

 1. 개요

본 프로그램은 자동차 제조 및 유통 시스템의 백엔드 데이터베이스와 연동되는 메뉴 구동형 C++ 콘솔 애플리케이션이다. Windows 환경에서 Microsoft Visual C++ 컴파일러와 MySQL C API를 사용하여 MySQL 데이터베이스에 직접 연결하고 다양한 비즈니스 분석 질의를 수행하도록 구현하였다.
Project 2 최종 구현은 MySQL C API 기반으로 작성되었으며,ODBC는 사용하지 않는다.
본 프로젝트의 데이터베이스는 BCNF 정규화를 적용하여 설계되었으며, 자동차 생산·유통·판매 프로세스를 통합적으로 관리할 수 있도록 구성하였다.

**채점 시 아래 환경 설정이 충족되어야 정상적으로 동작한다.**

 2. 개발 및 실행 환경

* 운영체제: Microsoft Windows 10 또는 Windows 11 (64-bit)
* 데이터베이스: MySQL Server 8.0 이상
* 개발 언어: C++17
* 컴파일러: Microsoft C/C++ Optimizing Compiler (MSVC cl.exe)
* 연동 라이브러리: MySQL C API (`libmysql.lib`)
* 문자셋: UTF-8

3. 사전 환경 설정 (Prerequisites)

프로그램 실행 전 MySQL Server가 정상적으로 설치되어 있어야 하며 프로젝트 데이터베이스가 생성되어 있어야 한다.

# 데이터베이스 정보

* Host: localhost
* Port: 3306
* Database: project2
* User: root
* Password: 1234

# MySQL C API 설치 경로

기본 설치 기준:

C:\Program Files\MySQL\MySQL Server 8.0\

필요 파일:

include\mysql.h
lib\libmysql.lib
lib\libmysql.dll

4. 컴파일 및 실행 방법

Visual Studio Developer Command Prompt(x64)를 실행한 후 소스 코드가 위치한 폴더로 이동한다.

# 컴파일

```cmd
cl /EHsc main.cpp ^
/I"C:\Program Files\MySQL\MySQL Server 8.0\include" ^
/Fe:main.exe ^
/link ^
/LIBPATH:"C:\Program Files\MySQL\MySQL Server 8.0\lib" ^
libmysql.lib
```

# DLL 복사

```cmd
copy "C:\Program Files\MySQL\MySQL Server 8.0\lib\libmysql.dll" .
```

# 실행

```cmd
main.exe
```

`/EHsc` 옵션은 C++ 표준 예외 처리 모델을 활성화하며, `libmysql.lib`는 MySQL C API와의 정적 링크를 담당한다.

5. 소스 코드 주요 구현 스펙

# 메뉴 구동형 인터페이스

무한 반복 루프와 switch-case 구조를 이용하여 사용자가 1번부터 7번까지의 비즈니스 질의를 선택적으로 수행할 수 있도록 구현하였다.

입력값이 숫자가 아니거나 범위를 벗어나는 경우 입력 버퍼를 초기화하고 재입력을 요구하는 예외 처리 로직을 포함한다.


# MySQL C API 기반 데이터베이스 연동

MySQL C API를 이용하여 데이터베이스와 직접 연결한다.

프로그램 시작 시:

```cpp
mysql_real_connect()
```

를 통해 세션을 생성하며,

프로그램 종료 시:

```cpp
mysql_close()
mysql_library_end()
```

를 호출하여 모든 연결 자원을 안전하게 반환한다.

# Prepared Statement 기반 입력 처리

사용자 입력을 요구하는 질의(Q2, Q5)는 Prepared Statement를 사용한다.

```cpp
mysql_stmt_prepare()
mysql_stmt_bind_param()
mysql_stmt_execute()
```

를 활용하여 입력 데이터를 SQL 문에 직접 결합하지 않고 파라미터로 바인딩함으로써 SQL Injection 공격을 방지하였다.

#  메모리 및 자원 관리

모든 질의 수행 이후 다음 자원을 명시적으로 해제한다.

```cpp
mysql_free_result()
mysql_stmt_free_result()
mysql_stmt_close()
```

이를 통해 메모리 누수와 데이터베이스 세션 누적 문제를 방지하였다.

# 결과 출력 및 오류 처리

쿼리 실행 결과는 동적으로 컬럼 정보를 읽어 표 형태로 출력한다.

또한 데이터가 존재하지 않는 경우:

[INFO] Query executed successfully, but no matching records found.

메시지를 출력하여 사용자에게 명확한 피드백을 제공한다.

데이터베이스 연결 오류 또는 SQL 실행 오류 발생 시 MySQL Error Message를 출력하여 디버깅이 가능하도록 구현하였다.

# 6. 구현된 비즈니스 질의

1. Sales Trends Analysis
2. Defective Part Tracking
3. Top Brands by Revenue
4. Top Brands by Unit Sales
5. Seasonal Sales Patterns
6. Dealer Inventory Efficiency
7. Supplier Coverage Analysis

모든 질의는 프로젝트 명세서에서 요구한 SQL 기능(Group By, Aggregate Function, Correlated Subquery, Prepared Statement 등)을 활용하여 구현하였다.

