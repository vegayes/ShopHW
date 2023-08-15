-- 자바는 EXPORT 
-- DB는 SCRIPT 

-- * 쇼핑몰 재고 (및 회원)관리 *
-- < 1. 테이블 설계 >

-- X) 상품 테이블 (==> 조회 )
-- 상품 코드(PR_ID), 카테고리(CATEGORY), 상품명(PR_NAME), 상품 가격(PR_PRICE), 판매 상태(PR_STATUS)
-->    PK                    
-->                   ------------------------  2번에서 JOIN 해야 할 값 ---------------------                   


-- 1) 카테고리 테이블 
-- 카테고리ID(CATEGORY_ID) , 카테고리명(CATEGORY)
-->    PK                           UNIQUE

  
-- 2) 재고 테이블 --1JOIN 
-- 상품 코드(PR_ID), 카테고리(CATEGORY),  상품명(PR_NAME) , 재고 수량(INVENTORY),
-->    PK                 FK                   UNIQUE           
-->                                                        DEFAULT           
-- 판매 상태(PR_STATUS), 거래처(ACCOUNT), 단가(PRICE)
-->                          UNIQUE    NOT NULL     
-->                                    DEFAULT            


-- 3) 재고 총 금액 파악 --2JOIN / 카테고리별 금액 계산 시,
-- 상품 코드(PR_ID) , 카테고리(CATEGORY), 상품명(PR_NAME), 금액(TOTAL) 
-->  PK                 FK               UNIQUE       NOT NULL (DEFAULT)

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- 4) 회원 테이블
-- 유저 ID , 유저PW ,  이름, 생년월일, 주소 , 구매건수, 등급,  마지막 구매 날짜?
-->  PK        NN               NN                       

-- 4-1) 등급
-- 등급명, 최소 구매, 최대 구매 
-->  PK      NN           NN

-- + 회원 구매 내역이 많으면 등급 나누기
-- + 회원되고 마지막 구매날짜가 12개월(MONTHS_BETWEEN) 이상이면 휴먼계정 설정 ()
-- + 이벤트 
  

--> 나중에 옵션 만들기
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

--------------------------------------------------------------------------------------------------------------------------
--                                        테이블 삭제 , 조회
--------------------------------------------------------------------------------------------------------------------------


DROP TABLE CATEGORY;
DROP TABLE INVENTORY;
DROP TABLE TOTAL_AMOUNT;
DROP TABLE SHOP_MEMBER;


SELECT * FROM CATEGORY;
SELECT * FROM INVENTORY;
SELECT * FROM TOTAL_AMOUNT;
SELECT * FROM SHOP_MEMBER;

--------------------------------------------------------------------------------------------------------------------------
--                                           테이블 설계
--------------------------------------------------------------------------------------------------------------------------

-- 1) 상품(PRODUCT) 테이블  (마지막에 CREATE 하기!)
-- 상품 코드(PR_ID), 카테고리(CATEGORY), 상품명(PR_NAME), 상품 가격(PR_PRICE), 판매 상태(PR_STATUS)
/*
CREATE TABLE PRODUCT( 
		PR_ID VARCHAR2(20) CONSTRAINT PR_ID_FK REFERENCES INVENTORY ON DELETE CASCADE, -- 재고 테이블에서 없애는경우 같이 없어짐.
		CATEGORY VARCHAR2(30),
		PR_NAME VARCHAR2(30),
		PR_PRICE NUMBER,
		PR_STATUS VARCHAR2(30) DEFAULT '판매 보류' CONSTRAINT PR_STATUS_NN NOT NULL
);

*/

-- 1) 카테고리 (CATEGORY) 테이블 
-- 카테고리ID(CATEGORY_ID) , 카테고리명(CATEGORY)
CREATE TABLE CATEGORY( 
	CATEGORY_ID VARCHAR2(10) CONSTRAINT CG_ID_PK  PRIMARY KEY,
	CATEGORY VARCHAR2(50) CONSTRAINT CG_NN NOT NULL
);

-- 2) 재고(INVENTORY) 테이블 -- 외래키 존재
-- 상품 코드(PR_ID), 카테고리(CATEGORY),  상품명(PR_NAME) , 재고 수량(INVENTORY), 거래처(ACCOUNT), 단가(PRICE)
CREATE TABLE INVENTORY( 
	PR_ID VARCHAR2(20) CONSTRAINT IT_ID_PK PRIMARY KEY,
	CATEGORY VARCHAR2(50),
	PR_NAME VARCHAR2(30) CONSTRAINT PR_NAME_UQ UNIQUE ,
	INVENTORY NUMBER  DEFAULT 0,
	ACCOUNT VARCHAR2(20),
	PRICE NUMBER CONSTRAINT IT_PR_NN NOT NULL
);

-- 3) 재고 금액 테이블
-- 상품 코드(PR_ID) , 카테고리(CATEGORY), 상품명(PR_NAME), 금액(TOTAL) 
-->  PK                 FK               UNIQUE       NOT NULL 
CREATE TABLE TOTAL_AMOUNT (
	PR_ID VARCHAR2(20),
	CATEGORY VARCHAR2(50),
	PR_NAME VARCHAR2(30),
	TOTAL NUMBER  DEFAULT 0    
);


-- 4) 회원 테이블 
-- 유저 ID , 유저PW ,  이름, 생년월일, 주소 , 구매건수, 등급,  마지막 구매 날짜?
--> PK               
CREATE TABLE SHOP_MEMBER ( 

	USER_ID VARCHAR2(20) CONSTRAINT SM_ID_PK PRIMARY KEY,
	USER_PW VARCHAR2(30),
	USER_NAME VARCHAR2(30) CONSTRAINT SM_NAME_NN NOT NULL,
	USER_BIRTHDAY NUMBER,
	USER_ADDRESS VARCHAR2(60),
	USER_COUNT NUMBER,
	USER_GRADE VARCHAR2(50),
	LAST_PURCHASE DATE
);

-- 4-1) 아이디별 구매건수 및 마지막 구매 날짜
-- 유저ID, 구매건수 ,마지막 구매 날짜

CREATE TABLE SHOP_PURCHASE( 	
	USER_ID VARCHAR2(20) CONSTRAINT SP_ID_PK PRIMARY KEY,
	PURCHASE_COUNT NUMBER,
	PURCHASE_LAST DATE
);


-- 4-2) 등급
-- 등급명, 최소 구매, 최대 구매 
-->  PK      NN           NN
CREATE TABLE SHOP_GRADE( 
	SHOP_GRADE VARCHAR2(30) CONSTRAINT SG_GRADE_PK PRIMARY KEY,
	MIN_PURCHASE NUMBER,
	MAX_PURCHASE NUMBER
);







-- 1) 회원테이블을 insert 할 때, 등급을 매겨서 넣고 싶음. 그러려면 회원테이블과 등급테이블이 만들어진 후에 


-- COMMENT 

COMMENT ON COLUMN CATEGORY.CATEGORY_ID  IS '카테고리 ID';
COMMENT ON COLUMN CATEGORY.CATEGORY  IS '카테고리명';

COMMENT ON COLUMN INVENTORY.PR_ID  IS '상품ID';
COMMENT ON COLUMN INVENTORY.CATEGORY  IS '카테고리명';
COMMENT ON COLUMN INVENTORY.PR_NAME  IS '상품명';
COMMENT ON COLUMN INVENTORY.INVENTORY  IS '재고';
COMMENT ON COLUMN INVENTORY.ACCOUNT  IS '거래처';
COMMENT ON COLUMN INVENTORY.PRICE  IS '가격';


COMMENT ON COLUMN TOTAL_AMOUNT.PR_ID  IS '상품ID';
COMMENT ON COLUMN TOTAL_AMOUNT.CATEGORY  IS '카테고리명';
COMMENT ON COLUMN TOTAL_AMOUNT.PR_NAME  IS '상품명';
COMMENT ON COLUMN TOTAL_AMOUNT.TOTAL  IS '상품 총 금액';


--------------------------------------------------------------------------------------------------------
--                                        테이블에 값 추가
--------------------------------------------------------------------------------------------------------


-- 1) 카테고리 값 추가
INSERT INTO CATEGORY VALUES('A0001', '상의');
INSERT INTO CATEGORY VALUES('A0002', '하의');
INSERT INTO CATEGORY VALUES('A0003', '원피스');
INSERT INTO CATEGORY VALUES('A0004', 'ACC');


-- 2) 재고 상품 값 추가 
/*
INSERT INTO INVENTORY VALUES('11','상의','반팔', 2, 'KH', 25000,
									(SELECT INVENTORY * PRICE FROM INVENTORY )); -- > 이렇게 하려면, 테이블 또 만들어서 가져와야 할 듯.
*/
INSERT INTO INVENTORY VALUES('1','상의','반팔', 1, 'KH', 25000);
INSERT INTO INVENTORY VALUES('2','하의','청바지', 2, 'KH', 25000 );
INSERT INTO INVENTORY VALUES('3','상의','긴팔', 3, 'KH', 55000 );
INSERT INTO INVENTORY VALUES('4','하의','카고 바지', 1, 'KH', 45000 );
INSERT INTO INVENTORY VALUES('5','원피스','체크', 2 , 'KH', 35000 );
INSERT INTO INVENTORY VALUES('6','원피스','땡땡이',DEFAULT , 'KH', 35000 );
INSERT INTO INVENTORY VALUES('7','ACC','하트',NULL , 'KH', 35000 );
INSERT INTO INVENTORY VALUES('8','ACC','다이아몬드',10 , 'KH', 55000 );
INSERT INTO INVENTORY VALUES('9','하의','트레이닝 바지', 3, 'KH', 15000); 


-- 3) 재고 금액 
/*
-- 단, 첫 번째 값이 있어야 하나.. ?
INSERT INTO TOTAL_AMOUNT VALUES('1','상의','반팔',  25000);
*/
INSERT INTO TOTAL_AMOUNT( PR_ID, CATEGORY, PR_NAME, TOTAL)
SELECT PR_ID, CATEGORY, PR_NAME, NVL((INVENTORY * PRICE), 0)
FROM INVENTORY i 
WHERE NOT EXISTS ( 
  	SELECT PR_ID 	
  	FROM TOTAL_AMOUNT t
  	WHERE i.PR_ID = t.PR_ID)
ORDER BY PR_ID;


/*
SELECT PR_ID, CATEGORY, PR_NAME, (INVENTORY * PRICE)
FROM INVENTORY  ;

SELECT * FROM INVENTORY;
SELECT * FROM TOTAL_AMOUNT;
*/

-- 4) 


INSERT INTO SHOP_GRADE VALUES('VIP', 50, 100);
INSERT INTO SHOP_GRADE VALUES('우수',20, 49);
INSERT INTO SHOP_GRADE VALUES('일반', 5, 19);
INSERT INTO SHOP_GRADE VALUES('입문', 0, 5);


	
--------------------------------------------------------------------------------------------------------
--                                     			 ! 조회 !
--------------------------------------------------------------------------------------------------------

SELECT * FROM INVENTORY;
SELECT * FROM TOTAL_AMOUNT;

--1) 상품 상태 확인
/*
SELECT PR_ID "상품 ID" , I.CATEGORY "카테고리", I.PR_NAME "상품명", I.PRICE "가격", 
CASE 
	WHEN INVENTORY <= 0 THEN '판매불가'
	WHEN INVENTORY < 5 THEN '판매가능 (재고요청)'
	WHEN INVENTORY >=5 THEN '판매가능'
	ELSE '..파악불가..'
END "상품재고상태"
FROM PRODUCT PR
RIGHT JOIN INVENTORY I USING(PR_ID)
ORDER BY I.CATEGORY DESC , I.PR_NAME ; 
*/

SELECT PR_ID "상품 ID" , CATEGORY "카테고리", PR_NAME "상품명", PRICE "가격", 
CASE 
	WHEN INVENTORY <= 0 THEN '판매불가'
	WHEN INVENTORY < 5 THEN '판매가능 (재고요청)'
	WHEN INVENTORY >=5 THEN '판매가능'
	ELSE '..파악불가..'
END "상품재고상태"
FROM INVENTORY 
ORDER BY CATEGORY DESC , PR_NAME ;

--2) 상품 카테고리 별 재고 확인 및 총 금액
SELECT I.CATEGORY "카테고리" , COUNT(*)"개수" , SUM(TOTAL) "총 금액"
FROM INVENTORY I 
JOIN TOTAL_AMOUNT  USING(PR_ID)
GROUP BY I.CATEGORY;

/*
SELECT CATEGORY "카테고리" , COUNT(*)"개수"
FROM INVENTORY I 
GROUP BY CATEGORY;
*/

--3) 재고가 0인 또는 NUll 인 값 파악하기
SELECT *
FROM INVENTORY 
WHERE INVENTORY = 0 
OR INVENTORY IS NULL;








