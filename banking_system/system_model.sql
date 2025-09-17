--Banking System Database Schema 
--Banking Tables

--1️ Customers – Stores bank customer information.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(100),
    DOB DATE,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20),
    Address TEXT,
    NationalID VARCHAR(20),
    TaxID VARCHAR(20),
    EmploymentStatus VARCHAR(50),
    AnnualIncome DECIMAL(15, 2),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
)

--2️ Accounts – Stores customer bank accounts.
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountType VARCHAR(20),
    Balance DECIMAL(15, 2),
    Currency VARCHAR(10),
    Status VARCHAR(20),
    BranchID INT,
    CreatedDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
)

--3️ Transactions – Logs all banking transactions.
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionType VARCHAR(20),
    Amount DECIMAL(15, 2),
    Currency VARCHAR(10),
    Date TIMESTAMP,
    Status VARCHAR(20),
    ReferenceNo VARCHAR(50),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
)

--4️ Branches – Bank branch details.
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100),
    Address TEXT,
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    ManagerID INT, 
    ContactNumber VARCHAR(20)
)

--5️ Employees – Stores bank staff details.
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    BranchID INT,
    FullName VARCHAR(100),
    Position VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(15, 2),
    HireDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
)

--Digital Banking & Payments

--6️ CreditCards – Customer credit card details.
CREATE TABLE CreditCards (
    CardID INT PRIMARY KEY,
    CustomerID INT,
    CardNumber VARCHAR(20),
    CardType VARCHAR(20),
    CVV VARCHAR(5),
    ExpiryDate DATE,
    Limit DECIMAL(15, 2),
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

--7️ CreditCardTransactions – Logs credit card transactions.
CREATE TABLE CreditCardTransactions (
    TransactionID INT PRIMARY KEY,
    CardID INT,
    Merchant VARCHAR(100),
    Amount DECIMAL(15, 2),
    Currency VARCHAR(10),
    Date TIMESTAMP,
    Status VARCHAR(20),
    FOREIGN KEY (CardID) REFERENCES CreditCards(CardID)
)

--8️ OnlineBankingUsers – Customers registered for internet banking.
CREATE TABLE OnlineBankingUsers (
    UserID INT PRIMARY KEY,
    CustomerID INT,
    Username VARCHAR(50),
    PasswordHash VARCHAR(256),
    LastLogin TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

--9️ BillPayments – Tracks utility bill payments.
CREATE TABLE BillPayments (
PaymentID INT PRIMARY KEY,
CustomerID INT,
BillerName VARCHAR(100),
Amount DECIMAL(15, 2),
Date TIMESTAMP,
Status VARCHAR(20),
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

--10 MobileBankingTransactions – Tracks mobile banking activity.
CREATE TABLE MobileBankingTransactions (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    DeviceID VARCHAR(100),
    AppVersion VARCHAR(20),
    TransactionType VARCHAR(20),
    Amount DECIMAL(15, 2),
    Date TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

--Loans & Credit
--1️1️ Loans – Stores loan details.
create table loans (LoanID varchar (10) primary key,
					CustomerID int,
					Coantype varchar (20),
					Amount decimal (20,2),
					InterestRate decimal (6,4),
					StartDate date,
					EndDate date,
					Status varchar (20), 
					foreign key (CustomerID) references Customers(CustomerID))

--1️2️ LoanPayments – Tracks loan repayments.
create table LoanPayments ( PaymentID varchar (10) primary key,
							LoanID varchar (10),
							AmountPaid decimal (20, 2),
							PaymentDate date,
							RemainingBalance decimal (20,2),
							foreign key (LoanID) references loans(LoanID)) 

--1️3️ CreditScores – Customer credit scores.
create table CreditScores ( CustomerID int,
							CreditScore int,
							UpdateDate date,
							foreign key (CustomerID) references Customers(CustomerID))

--1️4️ DebtCollection – Tracks overdue loans.
create table DebtCollection ( DebtID varchar(10) Primary key,
							  CustomerID int,
							  AmountDue decimal (20, 2),
							  DueDate date, 
							  CollectorAssigned int,
							  foreign key (CustomerID) references Customers(CustomerID))

--Compliance & Risk Management
  
--1️5️ KYC (Know Your Customer) – Stores customer verification info.
create table KYC (KYCID varchar (10) primary key,
			      CustomerID int,
				  DocumentType varchar (20),
				  DocumentNumber varchar (20),
				  VerifiedBY varchar (50),
				  foreign key (CustomerID) references Customers(CustomerID))

--1️6️ FraudDetection – Flags suspicious transactions.
create table FraudDetection (FraudID varchar (10) primary key,
							 CustomerID int,
							 TransactionID varchar (10),
							 RiskLevel varchar (20),
							 ReportedDate date,
							 foreign key (CustomerID) references Customers(CustomerID))
			 
--1️7️ AML (Anti-Money Laundering) Cases – Investigates financial crimes.
create table AML (CaseID varchar (10) primary key,
				  CustomerID int,
				  CustomerType varchar (20),
				  Status varchar (20),
				  InvestigatorID varchar (10),
				  foreign key (CustomerID) references Customers(CustomerID))

--1️8️ RegulatoryReports – Stores financial reports for regulators.
create table RegulatoryReports ( ReportID varchar (10) primary key,
								 ReportType varchar (20),
								 SubmissionDate date )

--Human Resources & Payroll
  
--1️9️ Departments – Stores company departments.
create table Departments ( DepartmentID varchar (10) primary key,
						   DeprtmentName varchar (20),
						   ManangerID varchar (10))

--2️0️ Salaries – Employee payroll data.
create table Salaries ( SalaryID varchar (10) primary key,
						EmployeeID  int,
						BaseSalary decimal (20,2), 
						Bonus decimal (20,2), 
						Deductions decimal (20,2), 
						PaymentDate date,
						foreign key (EmployeeID) references Employees(EmployeeID))

--2️1️ EmployeeAttendance – Tracks work hours.
create table EmployeeAttendance (
	AttendanceID int,
	EmployeeID int,
	CheckInTime datetime,
	CheckOutTime datetime,
	TotalHours decimal(5, 2),
	constraint PK_EmployeeAttendance_AttendanceID primary key(AttendanceID),
	constraint FK_EmployeeAttendance_EmployeeID foreign key(EmployeeID) references Employees(EmployeeID)
)

--Investments & Treasury
  
--2️2️ Investments – Stores customer investment details.
create table Investments (
	InvestmentID int, 
	CustomerID int,
	InvestmentType varchar(50),
	Amount decimal(18, 2),
	ROI decimal(10, 2),
	MaturityDate date,
	constraint PK_Investments_InvestID primary key(InvestmentID),
	constraint FK_Investments_CustomerID foreign key(CustomerID) references Customers(CustomerID)
)

--2️3️ StockTradingAccounts – Customers trading stocks via bank.
create table StockTradingAccounts (
	AccountID int,
	CustomerID int,
	BrokerageFirm varchar(100),
	TotalInvested decimal(18, 2),
	CurrentValue decimal(18, 2),
	constraint PK_StockTradingAccounts_AccountID primary key(AccountID),
	constraint FK_StockTradingAccounts_CustomerID foreign key(CustomerID) references Customers(CustomerID)
)

--2️4️ ForeignExchange – Tracks forex transactions.
create table ForeignExchange (
	FXID int,
	CustomerID int,
	CurrencyPair varchar(20),
	ExchangeRate decimal(18, 2),
	AmountExchanged decimal(18, 2),
	constraint PK_ForeignExchange_FXID primary key(FXID),
	constraint FK_ForeignExchange_CustomerID foreign key(CustomerID) references Customers(CustomerID)
)

--Insurance & Security
  
--2️5️ InsurancePolicies – Customer insurance plans.
create table InsurancePolicies (
	PolicyID int,
	CustomerID int,
	InsuranceType varchar(25),
	PremiumAmount decimal(18, 2),
	CoverageAmount decimal(18, 2),
	constraint PK_InsurancePolicies_PolicyID primary key(PolicyID),
	constraint FK_InsurancePolicies_Customer_ID foreign key(CustomerID) references Customers(CustomerID)
)

--2️6️ Claims – Tracks insurance claims.
create table Claims (
	ClaimID int,
	PolicyID int,
	ClaimAmount decimal(18, 2),
	Status int,
	FiledDate date,
	constraint PK_Claims_ClaimID primary key(ClaimID),
	constraint FK_Claims_PolicyID foreign key(PolicyID) references InsurancePolicies(PolicyID)
)

--2️7️ UserAccessLogs – Security logs for banking system users.
create table UserAccessLogs (
	LogID int,
	UserID int,
	ActionType varchar(50),
	Timestamp datetime,
	constraint PK_UserAccessLogs_LogID primary key(LogID)
)

--2️8️ CyberSecurityIncidents – Stores data breach or cyber attack cases.
create table CyberSecurityIncidents (
	IncidentID int,
	AffectedSystem varchar(50),
	ReportedDate date,
	ResolutionStatus varchar(50),
	constraint PK_CyberSecurityIncidents_IncidentID primary key(IncidentID)
)

--Merchant Services
  
--2️9️ Merchants – Stores merchant details for bank partnerships.
create table Merchants (
	MerchantID int,
	MerchantName varchar(30),
	Industry varchar(50),
	[Location] varchar(50),
	CustomerID int,
	constraint PK_Merchants_MerchantID primary key(MerchantID)
	constraint FK_Merchants_CustomerID foreign key CustomerID references Customers(CustomerID)
)

--3️0️ MerchantTransactions – Logs merchant banking transactions.
create table MerchantTransaction (
	TransactionID int,
	MerchantID int,
	Amount decimal(18, 2),
	PaymentMethod varchar(30),
	[Date] date,
	constraint PK_MerchantTransactions_TransactionID primary key(TransactionID),
	constraint FK_MerchantTransactions_MerchantID foreign key(MerchantID) references Merchants(MerchantID)
)
