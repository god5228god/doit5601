

--●상품 등록 프로시저

CREATE OR REPLACE PROCEDURE PRC_PRODUCT_CREATE
(
      P_USER_ID              IN PRODUCT.USER_ID%TYPE              -- 회원고유키 (NN)
    , P_PRODUCT_RELEASE_NAME IN PRODUCT.PRODUCT_RELEASE_NAME%TYPE -- 상품 발매명
    , P_PRODUCT_ALIAS        IN PRODUCT.PRODUCT_ALIAS%TYPE        -- 상품 별칭
    , P_MANUFACTURER_ID      IN PRODUCT.MANUFACTURER_ID%TYPE      -- 제조사 코드
    , P_PRODUCT_GRADE_ID     IN PRODUCT.PRODUCT_GRADE_ID%TYPE     -- 등급 코드 (NN)
    , P_PRODUCT_GENRE_ID     IN PRODUCT.PRODUCT_GENRE_ID%TYPE     -- 장르 코드 (NN)
    , P_PRODUCT_SIZE_ID      IN PRODUCT.PRODUCT_SIZE_ID%TYPE      -- 사이즈 코드 (NN)
    , P_WORK_NAME            IN PRODUCT.WORK_NAME%TYPE            -- 작품명
    , P_CHARACTER_NAME       IN PRODUCT.CHARACTER_NAME%TYPE       -- 캐릭터명
    , P_PURCHASE_DATETIME    IN PRODUCT.PURCHASE_DATETIME%TYPE    -- 구매일시
    , P_IS_OPENED            IN PRODUCT.IS_OPENED%TYPE            -- 개봉여부 (NN)
    , P_IS_PARTS_MISSING     IN PRODUCT.IS_PARTS_MISSING%TYPE     -- 파츠 누락 여부 (NN)
    , P_DESCRIPTIONS         IN PRODUCT.DESCRIPTIONS%TYPE         -- 상세설명
    , P_IMAGE_PATH_1         IN PRODUCT.IMAGE_PATH_1%TYPE         -- 이미지 1 (NN)
    , P_IMAGE_PATH_2         IN PRODUCT.IMAGE_PATH_2%TYPE         -- 이미지 2 (NN)
    , P_IMAGE_PATH_3         IN PRODUCT.IMAGE_PATH_3%TYPE         -- 이미지 3 (NN)
    , P_IS_PUBLIC            IN PRODUCT.IS_PUBLIC%TYPE            -- 공개 여부 (NN)
)
IS
    V_CNT NUMBER;
BEGIN
   
    -- 회원 정보 체크
    IF P_USER_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20010, '회원 정보가 유효하지 않습니다.');
    END IF;

    -- 선택사항 체크
    IF P_PRODUCT_GRADE_ID IS NULL OR P_PRODUCT_GENRE_ID IS NULL OR P_PRODUCT_SIZE_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20011, '상품 등급, 장르, 사이즈는 필수 선택 사항입니다.');
    END IF;

    -- 상태 및 공개 여부 체크
    IF P_IS_OPENED IS NULL OR P_IS_PARTS_MISSING IS NULL OR P_IS_PUBLIC IS NULL THEN
        RAISE_APPLICATION_ERROR(-20012, '개봉/누락/공개 여부를 모두 선택해주세요.');
    END IF;

    -- 이미지 3장 필수 체크
    IF P_IMAGE_PATH_1 IS NULL OR P_IMAGE_PATH_2 IS NULL OR P_IMAGE_PATH_3 IS NULL THEN
        RAISE_APPLICATION_ERROR(-20013, '상품 사진은 최소 3장이 필요합니다.');
    END IF;

    INSERT INTO PRODUCT 
    (
          PRODUCT_ID,           USER_ID,              PRODUCT_RELEASE_NAME
        , PRODUCT_ALIAS,        MANUFACTURER_ID,      PRODUCT_GRADE_ID
        , PRODUCT_GENRE_ID,     PRODUCT_SIZE_ID,      WORK_NAME
        , CHARACTER_NAME,       PURCHASE_DATETIME,    IS_OPENED
        , IS_PARTS_MISSING,     DESCRIPTIONS,         IMAGE_PATH_1
        , IMAGE_PATH_2,         IMAGE_PATH_3,         IS_PUBLIC
        , CREATED_AT
    ) VALUES 
    (
          PRODUCT_SEQ.NEXTVAL,  P_USER_ID,            P_PRODUCT_RELEASE_NAME
        , P_PRODUCT_ALIAS,      P_MANUFACTURER_ID,    P_PRODUCT_GRADE_ID
        , P_PRODUCT_GENRE_ID,   P_PRODUCT_SIZE_ID,    P_WORK_NAME
        , P_CHARACTER_NAME,     P_PURCHASE_DATETIME,  P_IS_OPENED
        , P_IS_PARTS_MISSING,   P_DESCRIPTIONS,       P_IMAGE_PATH_1
        , P_IMAGE_PATH_2,       P_IMAGE_PATH_3,       P_IS_PUBLIC
        , SYSDATE
    );
       
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20015, '상품등록이 실패하였습니다.');
    END IF;
    

    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
--------------------------------------------------------------------------------

-- ●상품 수정 프로시저

CREATE OR REPLACE PROCEDURE PRC_PRODUCT_UPDATE
(
      P_PRODUCT_ID           IN PRODUCT.PRODUCT_ID%TYPE           -- 상품코드 (PK)
    , P_USER_ID              IN PRODUCT.USER_ID%TYPE              -- 본인 확인용
    , P_PRODUCT_RELEASE_NAME IN PRODUCT.PRODUCT_RELEASE_NAME%TYPE -- 상품 발매명
    , P_PRODUCT_ALIAS        IN PRODUCT.PRODUCT_ALIAS%TYPE        -- 상품 별칭
    , P_MANUFACTURER_ID      IN PRODUCT.MANUFACTURER_ID%TYPE      -- 제조사 코드
    , P_PRODUCT_GRADE_ID     IN PRODUCT.PRODUCT_GRADE_ID%TYPE     -- 등급 코드 (NN)
    , P_PRODUCT_GENRE_ID     IN PRODUCT.PRODUCT_GENRE_ID%TYPE     -- 장르 코드 (NN)
    , P_PRODUCT_SIZE_ID      IN PRODUCT.PRODUCT_SIZE_ID%TYPE      -- 사이즈 코드 (NN)
    , P_WORK_NAME            IN PRODUCT.WORK_NAME%TYPE            -- 작품명
    , P_CHARACTER_NAME       IN PRODUCT.CHARACTER_NAME%TYPE       -- 캐릭터명
    , P_PURCHASE_DATETIME    IN PRODUCT.PURCHASE_DATETIME%TYPE    -- 구매일시
    , P_IS_OPENED            IN PRODUCT.IS_OPENED%TYPE            -- 개봉여부 (NN)
    , P_IS_PARTS_MISSING     IN PRODUCT.IS_PARTS_MISSING%TYPE     -- 파츠 누락 여부 (NN)
    , P_DESCRIPTIONS         IN PRODUCT.DESCRIPTIONS%TYPE         -- 상세설명
    , P_IMAGE_PATH_1         IN PRODUCT.IMAGE_PATH_1%TYPE         -- 이미지 1 (NN)
    , P_IMAGE_PATH_2         IN PRODUCT.IMAGE_PATH_2%TYPE         -- 이미지 2 (NN)
    , P_IMAGE_PATH_3         IN PRODUCT.IMAGE_PATH_3%TYPE         -- 이미지 3 (NN)
    , P_IS_PUBLIC            IN PRODUCT.IS_PUBLIC%TYPE            -- 공개 여부 (NN)
)
IS
    V_CNT NUMBER;
BEGIN
   
    -- 상품 정보 체크
    IF P_PRODUCT_ID IS NULL OR P_USER_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20023, 'ERR_ID_REQUIRED');
    END IF;


    -- 선택사항 체크
    IF P_PRODUCT_GRADE_ID IS NULL OR P_PRODUCT_GENRE_ID IS NULL OR P_PRODUCT_SIZE_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20011, '상품의 등급, 장르, 사이즈 정보는 필수입니다.');
    END IF;
    
    -- 상태 및 공개 여부 체크
    IF P_IS_OPENED IS NULL OR P_IS_PARTS_MISSING IS NULL OR P_IS_PUBLIC IS NULL THEN
        RAISE_APPLICATION_ERROR(-20012, '개봉 여부, 파츠 누락 여부, 공개 설정은 필수 선택 사항입니다.');
    END IF;
    
    -- 이미지 3장 필수 체크
    IF P_IMAGE_PATH_1 IS NULL OR P_IMAGE_PATH_2 IS NULL OR P_IMAGE_PATH_3 IS NULL THEN
        RAISE_APPLICATION_ERROR(-20013, '이미지 3장은 필수 항목입니다.');
    END IF;

    -- 상품 존재 및 본인 소유 여부 확인
    SELECT COUNT(*) INTO V_CNT
    FROM PRODUCT
    WHERE PRODUCT_ID = P_PRODUCT_ID AND USER_ID = P_USER_ID;

    IF V_CNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20021, '해당 상품이 없거나 수정 권한이 없습니다.');
    END IF;

    UPDATE PRODUCT
    SET PRODUCT_RELEASE_NAME = P_PRODUCT_RELEASE_NAME, PRODUCT_ALIAS = P_PRODUCT_ALIAS,   MANUFACTURER_ID    = P_MANUFACTURER_ID
     , PRODUCT_GRADE_ID     = P_PRODUCT_GRADE_ID,    PRODUCT_GENRE_ID = P_PRODUCT_GENRE_ID, PRODUCT_SIZE_ID  = P_PRODUCT_SIZE_ID
     , WORK_NAME            = P_WORK_NAME,           CHARACTER_NAME   = P_CHARACTER_NAME,   PURCHASE_DATETIME= P_PURCHASE_DATETIME
     , IS_OPENED            = P_IS_OPENED,           IS_PARTS_MISSING = P_IS_PARTS_MISSING, DESCRIPTIONS     = P_DESCRIPTIONS
     , IMAGE_PATH_1         = P_IMAGE_PATH_1,        IMAGE_PATH_2     = P_IMAGE_PATH_2,     IMAGE_PATH_3     = P_IMAGE_PATH_3
     , IS_PUBLIC            = P_IS_PUBLIC
    WHERE PRODUCT_ID = P_PRODUCT_ID;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20022, '수정 대상이 존재하지 않습니다.');
    END IF;

    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
--------------------------------------------------------------------------------

--●상품 삭제 프로시저

CREATE OR REPLACE PROCEDURE PRC_PRODUCT_DELETE
(
      P_PRODUCT_ID IN PRODUCT.PRODUCT_ID%TYPE 
    , P_USER_ID    IN PRODUCT.USER_ID%TYPE  
)
IS
    V_CNT NUMBER;
BEGIN
    -- 파라미터 체크
    IF P_PRODUCT_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20023, '삭제할 상품 번호가 입력되지 않았습니다.');
    END IF;
    
    IF P_USER_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20010, '회원 정보가 유효하지 않습니다.');
    END IF;

    -- 상품 존재 및 본인 여부 확인
    SELECT COUNT(*) INTO V_CNT
    FROM PRODUCT
    WHERE PRODUCT_ID = P_PRODUCT_ID AND USER_ID = P_USER_ID;

    IF V_CNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20024, '삭제 권한이 없거나 이미 존재하지 않는 상품입니다.');
    END IF;

    -- 진행 중인 경매 여부 확인 (함수 FN_IS_AUCTION_FINISHED 활용)
    -- 해당 상품으로 등록된 경매들 중, 함수 결과 0 = 경매중
    SELECT COUNT(*) INTO V_CNT
    FROM AUCTION_REGISTRATION
    WHERE PRODUCT_ID = P_PRODUCT_ID
      AND FN_IS_AUCTION_FINISHED(AUCTION_ID) = 0; 

    IF V_CNT > 0 THEN
        RAISE_APPLICATION_ERROR(-20016, '진행 중인 경매가 존재합니다.');
    END IF;

    -- 이미지 테이블 삭제
    DELETE FROM PRODUCT_IMAGE
    WHERE PRODUCT_ID = P_PRODUCT_ID;
    
    -- 상품 삭제
    DELETE FROM PRODUCT
    WHERE PRODUCT_ID = P_PRODUCT_ID;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20025, '삭제 대상이 존재하지 않습니다.');
    END IF;

    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;

--------------------------------------------------------------------------------

-- ●입찰 생성 프로시저

CREATE OR REPLACE PROCEDURE PRC_AUCTION_BID_CREATE
(
    P_AUCTION_ID   IN NUMBER
  , P_USER_ID      IN NUMBER  
  , P_BID_PRICE    IN NUMBER
  , P_RESULT       OUT VARCHAR2
)
IS
    V_SELLER_ID      NUMBER;
    V_CURRENT_PRICE  NUMBER;
    V_USER_MONEY     NUMBER;
    V_MAX_PRICE      NUMBER; -- 최대 상한가 
    V_MY_BID_COUNT   NUMBER; -- 내 입찰 기록 확인용
    V_CANCEL_COUNT   NUMBER; -- 경매 취소 확인용
BEGIN
	
	-- 경매 취소 여부 확인
	SELECT COUNT(*) INTO V_CANCEL_COUNT
    FROM AUCTION_CANCEL_HISTORY
    WHERE AUCTION_ID = P_AUCTION_ID;

    IF V_CANCEL_COUNT > 0 THEN
        P_RESULT := '이미 취소된 경매에는 입찰할 수 없습니다.';
        RETURN;
    END IF;
	
	
  
    -- 본인 경매 입찰 방지
    SELECT USER_ID INTO V_SELLER_ID 
    FROM PRODUCT
    WHERE PRODUCT_ID = (SELECT PRODUCT_ID
                        FROM AUCTION_REGISTRATION 
                        WHERE AUCTION_ID = P_AUCTION_ID);
                        
    IF V_SELLER_ID = P_USER_ID THEN
        P_RESULT := '본인이 등록한 경매에는 입찰할 수 없습니다.';
        RETURN;
    END IF;
    
    -- 본인 연속 추가 입찰 방지
    IF P_USER_ID = (SELECT USER_ID 
                              FROM 
                   	 		  (SELECT USER_ID,  RANK() OVER (ORDER BY BID_PRICE DESC, BID_TIME ASC) 
                 		      FROM AUCTION_BID_PARTICIPATION
                 	          WHERE AUCTION_ID = P_AUCTION_ID) 
               		          WHERE RK = 1) THEN
       P_RESULT := '현재 귀하가 최고가 입찰자입니다. 연속 입찰은 불가능합니다.';
       RETURN;
     END IF;

    -- 현재 입찰가 조회 및 유효성 검사
    V_CURRENT_PRICE := FN_GET_AUCTION_CURRENT_PRICE(P_AUCTION_ID);

    IF P_BID_PRICE <= V_CURRENT_PRICE THEN
        P_RESULT := '현재가(' || V_CURRENT_PRICE || '원)보다 높은 금액을 입력해야 합니다.';
        RETURN; 
    END IF;
    
    -- 경매 입찰 상한가 검사
    V_MAX_PRICE := FN_GET_BID_MAX_LIMIT(P_AUCTION_ID); -- 상한가 조회

     IF P_BID_PRICE > V_MAX_PRICE THEN
    P_RESULT := '상한가(' || V_MAX_PRICE || '원)를 초과하여 입찰할 수 없습니다.';
    RETURN;
    
    END IF;

    -- 동시 입찰 제한 체크 (최대 10회)
    IF FN_GET_ACTIVE_BID_COUNT(P_USER_ID) >= 10 THEN 
        P_RESULT := '동시에 참여 가능한 경매 횟수 10회를 초과했습니다.';
        RETURN;
    END IF;
    
    경매취소이력테이블에 이력이 있으면 해당 경매가 입찰이 안되게 막아야함 
    경매취소이력테이블에 있는 auctionid를 가져와서 
    그 auctionid가 진행중인 경매 아이디랑 같으면 입찰을 못하게
    

    -- 해당 경FN_GET_BID_MAX_LIMIT 신규 참여 여부 확인 (보증금 로직)
    SELECT COUNT(*) INTO V_MY_BID_COUNT
    FROM AUCTION_BID_PARTICIPATION
    WHERE AUCTION_ID = P_AUCTION_ID AND USER_ID = P_USER_ID;

    IF V_MY_BID_COUNT = 0 THEN
        V_USER_MONEY := FN_GET_USER_MONEY_BALANCE(P_USER_ID);
        
        IF V_USER_MONEY < 30000 THEN
           P_RESULT := '보증금(30,000원) 결제를 위한 머니가 부족합니다.';
           RETURN;
        END IF;

    -- 보증금 차감 이력 삽입 (머니분류코드 EX) 3 = 보증금 차감)
        INSERT INTO MONEY_TRANSACTION_HISTORY (MONEY_ID, USER_ID, MONEY_TYPE_ID, AUCTION_ID, AMOUNT, CREATED_AT)
        VALUES (MONEY_TRANSACTION_SEQ.NEXTVAL, P_USER_ID, 3, P_AUCTION_ID, -30000, SYSDATE); 
    END IF;

    -- 입찰 기록 삽입
    INSERT INTO AUCTION_BID_PARTICIPATION (BID_ID, AUCTION_ID, USER_ID, BID_TIME, BID_PRICE)
    VALUES (BID_SEQ.NEXTVAL, P_AUCTION_ID, P_USER_ID, SYSTIMESTAMP, P_BID_PRICE);

    P_RESULT := 'SUCCESS';
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        P_RESULT := '에러 발생'; 
END;

--------------------------------------------------------------------------------

--●경매 마감 및 낙찰 처리 프로시저 

CREATE OR REPLACE PROCEDURE PRC_AUCTION_CLOSE
(
    P_AUCTION_ID IN  NUMBER
  , P_RESULT     OUT VARCHAR2(300)
)
IS
    V_BID_COUNT      NUMBER;
    V_WINNER_BID_ID  NUMBER;
BEGIN

    -- 해당 경매의 입찰 참여 인원 확인
    SELECT COUNT(*) INTO V_BID_COUNT
    FROM AUCTION_BID_PARTICIPATION
    WHERE AUCTION_ID = P_AUCTION_ID;

    --  입찰자가 없는 경우 유찰
    IF V_BID_COUNT = 0 THEN
        P_RESULT := '해당 경매가 유찰되었습니다';
        
    -- 입찰자가 있는 경우(낙찰 처리)
    ELSE
    
        -- 최고가 입찰자가 2명 이상일 경우 입찰 시간이 빠른 순서
        SELECT BID_ID INTO V_WINNER_BID_ID
        FROM (
            SELECT BID_ID
            FROM AUCTION_BID_PARTICIPATION
            WHERE AUCTION_ID = P_AUCTION_ID
            ORDER BY BID_PRICE DESC, BID_TIME ASC
        )
        WHERE ROWNUM = 1;

        -- 낙찰 결과 테이블 삽입
        INSERT INTO AUCTION_WINNING_RESULT 
        (
            BID_RESULT_ID
           ,BID_ID
           ,CREATED_AT
        ) VALUES 
        (
            BID_RESULT_SEQ.NEXTVAL
           ,V_WINNER_BID_ID
           ,SYSDATE
        );

        P_RESULT := '낙찰 성공!!';
    END IF;

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        P_RESULT := '존재하지 않는 경매입니다.';
    WHEN OTHERS THEN
        ROLLBACK;
        P_RESULT := 'ERROR:';
END;

