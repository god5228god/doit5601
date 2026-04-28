-- ! 유의사항 ! --

-- [트리거 - 뮤테이팅 테이블(Mutating Table)]
-- 현재 패널티에 대한 트리거가 자기 자신을 참조하는 형태로 작성되어 있음. (프로시저 INSERT 후 트리거에서 SELECT)
-- 정상 작동 한다면 그대로 사용하면 되지만, 에러가 발생한다면 트리거 제거 후
-- 모든 로직이 프로시저 하나로만 처리되도록 변경이 필요할 수 있음.
-- (프로시저 단일로 처리하는 코드는 주석 처리하여 함께 작성해 두었으므로 바로 사용 가능.)

-- ==>> 2026.04.23) 뮤테이팅 이슈 발생하여 트리거 주석 처리 및 프로시저 만으로 로직 처리하도록 수정.


--------------------------------------------------------------------------------------------------------------------------------------------------


-- 패널티 부여 프로시저
--  ㄴ 패널티 부여 사유는 기재하지 않는 것으로 결정됨. (2026-04-21 12:48:02)

<<<<<<< HEAD
-- 프로시저 1개로 모두 처리 (패널티 부여 + 계정 정지)
--  ㄴ 학습이라는 프로젝트 목적에 충실하기 위해 프로시저-트리거 형태로 분리하여 구현.
--  ㄴ 뮤테이팅 테이블(Mutating Table) 이슈 발생시 가장 상단의 유의사항에 기재된 대로 처리. 
=======
-- <프로시저 1개로 모두 처리 (패널티 부여 + 계정 정지)>
>>>>>>> 02706d13cfda250fcb449d8a7307b6f65bbc423a
CREATE OR REPLACE PROCEDURE PRC_PENALTY_ASSIGN
( P_USER_ID             IN      USERS.USER_ID%TYPE
, P_ADMIN_ACCOUNT_ID    IN      ADMIN_ACCOUNT.ADMIN_ACCOUNT_ID%TYPE
, P_PENALTY_TYPE_ID     IN      PENALTY_HISTORY.PENALTY_SCORE%TYPE
, P_PENALTY_SCORE       IN      PENALTY_HISTORY.PENALTY_SCORE%TYPE
)
IS
	V_FLAG_ACTIVE_USER			CHAR(1);
	V_FLAG_BANNED_USER			CHAR(1);

    V_PENALTY_ID                PENALTY_HISTORY.PENALTY_ID%TYPE;
    V_TOTAL_PENALTY_SCORE       PENALTY_HISTORY.PENALTY_SCORE%TYPE;
    V_PENALTY_END_DATE          PENALTY_STATUS.PENALTY_END_DATE%TYPE;
BEGIN
<<<<<<< HEAD
-- 회원 유효성 체크) 활동 회원인지 확인
	SELECT
		CASE WHEN EXISTS(SELECT 1 FROM USER_PROFILE WHERE USER_ID = V_USER_ID)
=======
	-- 회원 유효성 체크) 활동 회원인지 확인
	SELECT
		CASE WHEN EXISTS(SELECT 1 FROM USER_PROFILE WHERE USER_ID = P_USER_ID)
>>>>>>> 02706d13cfda250fcb449d8a7307b6f65bbc423a
		     THEN 'Y'
		     
		     ELSE 'N'
		END INTO V_FLAG_ACTIVE_USER
	FROM DUAL;

	-- 활동하지 않는 회원이라면(=탈퇴한 회원이라면) 예외 발생 처리
	IF V_FLAG_ACTIVE_USER = 'N' THEN
<<<<<<< HEAD
		RAISE IMPOSE_PENALTY_TO_DEACTIVATED_USER;
	END IF;
	

-- 회원 유효성 체크) 영구 정지 처리된 회원이지 확인
=======
		RAISE ERR_PENALTY_TO_DEACTIVATED_USER;
	END IF;
	

	-- 회원 유효성 체크) 영구 정지 처리된 회원이지 확인
>>>>>>> 02706d13cfda250fcb449d8a7307b6f65bbc423a
	-- 유저의 현재 패널티 총점 확인
    SELECT SUM(PH.PENALTY_SCORE) INTO V_TOTAL_PENALTY_SCORE
    FROM PENALTY_HISTORY PH LEFT OUTER JOIN PENALTY_CANCEL PC
         ON PH.PENALTY_ID = PC.PENALTY_ID
<<<<<<< HEAD
    WHERE PH.USER_ID = :NEW.USER_ID
=======
    WHERE PH.USER_ID = P_USER_ID
>>>>>>> 02706d13cfda250fcb449d8a7307b6f65bbc423a
      AND PENALTY_CANCEL_ID IS NULL;

	-- 영구 정지 점수(4점 이상)면 이미 영구 정지된 회원이므로 예외 발생
	IF V_TOTAL_PENALTY_SCORE >= 4 THEN
<<<<<<< HEAD
		RAISE IMPOSE_PENALTY_TO_BANNED_USER
=======
		RAISE ERR_PENALTY_TO_BANNED_USER;
>>>>>>> 02706d13cfda250fcb449d8a7307b6f65bbc423a
	END IF;
	
	
	
<<<<<<< HEAD
-- 회원 유효성 검사 이후) 패널티 부여 로직 수행
=======
	-- 회원 유효성 검사 이후) 패널티 부여 로직 수행
>>>>>>> 02706d13cfda250fcb449d8a7307b6f65bbc423a
    -- 패널티 이력의 시퀸스 값을 변수로 저장
    -- ㄴ패널티 상태 테이블 INSERT 문에서 재사용하기 위한 목적.
    V_PENALTY_ID := PENALTY_SEQ.NEXTVAL;

    -- 패널티 점수 부여
    INSERT INTO PENALTY_HISTORY (PENALTY_ID, USER_ID, PENALTY_TYPE_ID, ADMIN_ACCOUNT_ID, PENALTY_SCORE, CREATED_AT)
<<<<<<< HEAD
    VALUES (V_PENALTY_ID, V_USER_ID, V_PENALTY_TYPE_ID, V_ADMIN_ACCOUNT_ID, V_PENALTY_SCORE, SYSDATE);
    
    -- 패널티 총점 재계산 (기존의 패널티 점수 + 추가로 부여한 패널티 점수)
    V_TOTAL_PENALTY_SCORE := V_TOTAL_PENALTY_SCORE + V_PENALTY_SCORE;

=======
    VALUES (V_PENALTY_ID, P_USER_ID, P_PENALTY_TYPE_ID, P_ADMIN_ACCOUNT_ID, P_PENALTY_SCORE, SYSDATE);
    
    
    -- 패널티 부여 후, 패널티 총점 재계산
    SELECT SUM(PH.PENALTY_SCORE) INTO V_TOTAL_PENALTY_SCORE
    FROM PENALTY_HISTORY PH LEFT OUTER JOIN PENALTY_CANCEL PC
         ON PH.PENALTY_ID = PC.PENALTY_ID
    WHERE PH.USER_ID = P_USER_ID
      AND PENALTY_CANCEL_ID IS NULL;
>>>>>>> 02706d13cfda250fcb449d8a7307b6f65bbc423a


    -- 패널티 점수가 일정치 이상(1점 초과)이면 제재 발생
    IF V_TOTAL_PENALTY_SCORE > 1 THEN
        CASE
            -- 4점 이상: 영구 정지
            WHEN V_TOTAL_PENALTY_SCORE >= 4
            THEN V_PENALTY_END_DATE := TO_DATE('9999-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS');

            -- 3점 이상: 30일 정지
            -- 오늘을 기준으로 30일 뒤 23시59분59초까지 계정 정지
            WHEN V_TOTAL_PENALTY_SCORE >= 3
            THEN V_PENALTY_END_DATE := TRUNC(SYSDATE + 30) + (1 - 1/86400);

            -- 그 외(2점 이상): 7일 정지
            -- 오늘을 기준으로 7일 뒤 23시59분59초까지 계정 정지
            ELSE V_PENALTY_END_DATE := TRUNC(SYSDATE + 7) + (1 - 1/86400);
        END CASE;
        
        INSERT INTO PENALTY_STATUS (PENALTY_STATUS_ID, PENALTY_ID, PENALTY_START_DATE, PENALTY_END_DATE)
        VALUES (PENALTY_STATUS_SEQ.NEXTVAL, V_PENALTY_ID, SYSDATE, V_PENALTY_END_DATE);
    END IF;



	EXCEPTION
		-- 활동하지 않는 회원(=탈퇴 회원)에게 패널티 부여 시도
<<<<<<< HEAD
		WHEN IMPOSE_PENALTY_TO_DEACTIVATED_USER;
		THEN
		
		-- 이미 영구정지된 회원에게 추가 패널티 부여 시도(=의미 없는 패널티 부여)
		WHEN IMPOSE_PENALTY_TO_BANNED_USER
		THEN
=======
		WHEN ERR_PENALTY_TO_DEACTIVATED_USER
		THEN RAISE_APPLICATION_ERROR(-21000, '탈퇴한 회원에게는 패널티 부여가 불가능합니다.');
		
		-- 이미 영구정지된 회원에게 추가 패널티 부여 시도(=의미 없는 패널티 부여)
		WHEN ERR_PENALTY_TO_BANNED_USER
		THEN RAISE_APPLICATION_ERROR(-21001, '이미 영구 정지 처리된 회원에게는 추가 패널티 부여가 불가능합니다.');
		
		WHEN OTHERS
		THEN RAISE; -- 에러 전파 (ROLLBACK 은 프로시저 호출단에서 컨트롤)
END;


/*
-- [미사용] <프로시저-트리거 분리 구현 (패널티 상태 처리 로직을 트리거로 분리)>
CREATE OR REPLACE PROCEDURE PRC_PENALTY_ASSIGN
( P_USER_ID             IN      USERS.USER_ID%TYPE
, P_ADMIN_ACCOUNT_ID    IN      ADMIN_ACCOUNT.ADMIN_ACCOUNT_ID%TYPE
, P_PENALTY_TYPE_ID     IN      PENALTY_HISTORY.PENALTY_SCORE%TYPE
, P_PENALTY_SCORE       IN      PENALTY_HISTORY.PENALTY_SCORE%TYPE
)
IS
	V_FLAG_ACTIVE_USER			CHAR(1);
	V_FLAG_BANNED_USER			CHAR(1);

	-- V_PENALTY_ID                PENALTY_HISTORY.PENALTY_ID%TYPE;
    V_TOTAL_PENALTY_SCORE       PENALTY_HISTORY.PENALTY_SCORE%TYPE;
    V_PENALTY_END_DATE          PENALTY_STATUS.PENALTY_END_DATE%TYPE;
BEGIN
	-- 회원 유효성 체크) 활동 회원인지 확인
	SELECT
		CASE WHEN EXISTS(SELECT 1 FROM USER_PROFILE WHERE USER_ID = P_USER_ID)
		     THEN 'Y'
		     
		     ELSE 'N'
		END INTO V_FLAG_ACTIVE_USER
	FROM DUAL;

	-- 활동하지 않는 회원이라면(=탈퇴한 회원이라면) 예외 발생 처리
	IF V_FLAG_ACTIVE_USER = 'N' THEN
		RAISE ERR_PENALTY_TO_DEACTIVATED_USER;
	END IF;
	

	-- 회원 유효성 체크) 영구 정지 처리된 회원이지 확인
	-- 유저의 현재 패널티 총점 확인
    SELECT SUM(PH.PENALTY_SCORE) INTO V_TOTAL_PENALTY_SCORE
    FROM PENALTY_HISTORY PH LEFT OUTER JOIN PENALTY_CANCEL PC
         ON PH.PENALTY_ID = PC.PENALTY_ID
    WHERE PH.USER_ID = P_USER_ID
      AND PENALTY_CANCEL_ID IS NULL;

	-- 영구 정지 점수(4점 이상)면 이미 영구 정지된 회원이므로 예외 발생
	IF V_TOTAL_PENALTY_SCORE >= 4 THEN
		RAISE ERR_PENALTY_TO_BANNED_USER;
	END IF;
	
	
	
	-- 회원 유효성 검사 이후) 패널티 부여 로직 수행
    -- 패널티 점수 부여
	--  ㄴ 패널티 점수 부여 후 정지 처리는 트리거로 수행
    INSERT INTO PENALTY_HISTORY (PENALTY_ID, USER_ID, PENALTY_TYPE_ID, ADMIN_ACCOUNT_ID, PENALTY_SCORE, CREATED_AT)
    VALUES (PENALTY_SEQ.NEXTVAL, P_USER_ID, P_PENALTY_TYPE_ID, P_ADMIN_ACCOUNT_ID, P_PENALTY_SCORE, SYSDATE);

	
	EXCEPTION
		-- 활동하지 않는 회원(=탈퇴 회원)에게 패널티 부여 시도
		WHEN ERR_PENALTY_TO_DEACTIVATED_USER
		THEN RAISE_APPLICATION_ERROR(-21000, '탈퇴한 회원에게는 패널티 부여가 불가능합니다.');
		
		-- 이미 영구정지된 회원에게 추가 패널티 부여 시도(=의미 없는 패널티 부여)
		WHEN ERR_PENALTY_TO_BANNED_USER
		THEN RAISE_APPLICATION_ERROR(-21001, '이미 영구 정지 처리된 회원에게는 추가 패널티 부여가 불가능합니다.');
		
		WHEN OTHERS
		THEN RAISE; -- 에러 전파 (ROLLBACK 은 프로시저 호출단에서 컨트롤)
>>>>>>> 02706d13cfda250fcb449d8a7307b6f65bbc423a
END;





--------------------------------------------------------------------------------------------------------------------------------------------------


-- 패널티 취소 프로시저
<<<<<<< HEAD
-- 프로시저 1개로 모두 처리 (패널티 취소 + 계정 정지 레코드 삭제)
--  ㄴ 학습이라는 프로젝트 목적에 충실하기 위해 프로시저-트리거 형태로 분리하여 구현.
--  ㄴ 뮤테이팅 테이블(Mutating Table) 이슈 발생시 트리거 없이 프로시저 만으로 로직 처리 (가장 상단의 유의사항 참조)
/*
=======
>>>>>>> 02706d13cfda250fcb449d8a7307b6f65bbc423a
CREATE OR REPLACE PROCEDURE PRC_PENALTY_CANCEL
( P_PENALTY_ID              IN          PENALTY_HISTORY.PENALTY_ID%TYPE
, P_ADMIN_ACCOUNT_ID        IN          ADMIN_ACCOUNT.ADMIN_ACCOUNT_ID%TYPE
, P_CANCEL_REASON           IN          PENALTY_CANCEL.CANCEL_REASON%TYPE
)
IS
	V_USER_ID							USERS.USER_ID%TYPE;
	V_TOTAL_PENALTY_SCORE				NUMBER;
BEGIN
	-- 패널티 취소 처리
    INSERT INTO PENALTY_CANCEL(PENALTY_CANCEL_ID, PENALTY_ID, ADMIN_ACCOUNT_ID, CANCEL_REASON, CANCELED_AT)
    VALUES(PENALTY_CANCEL_SEQ.NEXTVAL, P_PENALTY_ID, P_ADMIN_ACCOUNT_ID, P_CANCEL_REASON, SYSDATE);

	
	-- 취소된 패널티의 유저ID 확인
	SELECT USER_ID
	INTO V_USER_ID
	FROM PENALTY_HISTORY
	WHERE PENALTY_ID = P_PENALTY_ID;
	
	
	-- 해당 유저의 현재 패널티 총점 계산
	SELECT NVL(SUM(PH.PENALTY_SCORE), 0)
	INTO V_TOTAL_PENALTY_SCORE
    FROM PENALTY_HISTORY PH LEFT OUTER JOIN PENALTY_CANCEL PC
         ON PH.PENALTY_ID = PC.PENALTY_ID
    WHERE PH.USER_ID = V_USER_ID
      AND PENALTY_CANCEL_ID IS NULL;
	
	
	-- IF) 패널티 총점이 1점 이하일 경우 → 모든 패널티 상태 해제
	IF V_TOTAL_PENALTY_SCORE <= 1 THEN
		UPDATE PENALTY_STATUS
		SET PENALTY_END_DATE = SYSDATE
		WHERE PENALTY_ID IN ( SELECT PENALTY_ID
							  FROM PENALTY_HISTORY
							  WHERE USER_ID = V_USER_ID )
		  AND PENALTY_END_DATE > SYSDATE;
	-- IF) 패널티 총점이 2점 이상일 경우 → 현재 적용중인 패널티 종료 날짜 재조정
	ELSE
		CASE
            -- 4점 이상: 영구 정지
            WHEN V_TOTAL_PENALTY_SCORE >= 4
            THEN
            	 UPDATE PENALTY_STATUS
            	 SET PENALTY_END_DATE = TO_DATE('9999-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS')
            	 WHERE PENALTY_ID IN ( SELECT PENALTY_ID
									   FROM PENALTY_HISTORY
									   WHERE USER_ID = V_USER_ID )
			  	   AND PENALTY_END_DATE > SYSDATE;

            -- 3점 이상: 시작일부터 30일 정지
            WHEN V_TOTAL_PENALTY_SCORE >= 3
            THEN
            	 UPDATE PENALTY_STATUS
            	 SET PENALTY_END_DATE = TRUNC(PENALTY_START_DATE + 30) + (1 - 1/86400)
            	 WHERE PENALTY_ID IN ( SELECT PENALTY_ID
									   FROM PENALTY_HISTORY
									   WHERE USER_ID = V_USER_ID )
			  	   AND PENALTY_END_DATE > SYSDATE;
            -- 그 외(2점 이상): 시작일부터 7일 정지
            ELSE
            	 UPDATE PENALTY_STATUS
            	 SET PENALTY_END_DATE = TRUNC(PENALTY_START_DATE + 7) + (1 - 1/86400)
            	 WHERE PENALTY_ID IN ( SELECT PENALTY_ID
									   FROM PENALTY_HISTORY
									   WHERE USER_ID = V_USER_ID )
			  	   AND PENALTY_END_DATE > SYSDATE;
        END CASE;
	END IF;
END;





/*
-- [미사용] <프로시저-트리거 분리 구현 방식>
CREATE OR REPLACE PROCEDURE PRC_PENALTY_CANCEL
( P_PENALTY_ID              IN          PENALTY_HISTORY.PENALTY_ID%TYPE
, P_ADMIN_ACCOUNT_ID        IN          ADMIN_ACCOUNT.ADMIN_ACCOUNT_ID%TYPE
, P_CANCEL_REASON           IN          PENALTY_CANCEL.CANCEL_REASON%TYPE
)
IS
BEGIN
    -- 패널티 취소 처리
    INSERT INTO PENALTY_CANCEL(PENALTY_CANCEL_ID, PENALTY_ID, ADMIN_ACCOUNT_ID, CANCEL_REASON, CANCELED_AT)
    VALUES(PENALTY_CANCEL_SEQ.NEXTVAL, P_PENALTY_ID, P_ADMIN_ACCOUNT_ID, P_CANCEL_REASON, SYSDATE);

	-- 패널티 취소에 대한 추가 로직 필요시 작성 가능...
END;
*/

--------------------------------------------------------------------------------------------------------------------------------------------------



--================================================================================
-- 2026.04.23) 뮤테이팅 이슈 발생하여 모든 트리거 주석 처리 및 삭제
--DROP TRIGGER TRG_PENALTY_AFTER_INS;
--DROP TRIGGER TRG_PENALTY_CANCEL_AFTER_INS;
--================================================================================
/*
-- 패널티 부여 후 상태 반영 트리거
CREATE OR REPLACE TRIGGER TRG_PENALTY_AFTER_INS
	AFTER INSERT ON PENALTY_HISTORY
	FOR EACH ROW
DECLARE
    V_TOTAL_PENALTY_SCORE       PENALTY_HISTORY.PENALTY_SCORE%TYPE;
    V_PENALTY_END_DATE          PENALTY_STATUS.PENALTY_END_DATE%TYPE;
BEGIN
    -- 패널티 점수를 받은 유저의 현재 총점 확인
    SELECT SUM(PH.PENALTY_SCORE) INTO V_TOTAL_PENALTY_SCORE
    FROM PENALTY_HISTORY PH LEFT OUTER JOIN PENALTY_CANCEL PC
         ON PH.PENALTY_ID = PC.PENALTY_ID
    WHERE PH.USER_ID = :NEW.USER_ID
      AND PENALTY_CANCEL_ID IS NULL;
    
    
    -- 패널티 점수가 일정치 이상(1점 초과)이면 제재 발생
    IF V_TOTAL_PENALTY_SCORE > 1 THEN
        CASE
            -- 4점 이상: 영구 정지
            WHEN V_TOTAL_PENALTY_SCORE >= 4
            THEN V_PENALTY_END_DATE := TO_DATE('9999-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS');

            -- 3점 이상: 30일 정지
            -- 오늘을 기준으로 30일 뒤 23시59분59초까지 계정 정지
            WHEN V_TOTAL_PENALTY_SCORE >= 3
            THEN V_PENALTY_END_DATE := TRUNC(SYSDATE + 30) + (1 - 1/86400);

            -- 그 외(2점 이상): 7일 정지
            -- 오늘을 기준으로 7일 뒤 23시59분59초까지 계정 정지
            ELSE V_PENALTY_END_DATE := TRUNC(SYSDATE + 7) + (1 - 1/86400);
        END CASE;

        INSERT INTO PENALTY_STATUS (PENALTY_STATUS_ID, PENALTY_ID, PENALTY_START_DATE, PENALTY_END_DATE)
        VALUES (PENALTY_STATUS_SEQ.NEXTVAL, :NEW.PENALTY_ID, SYSDATE, V_PENALTY_END_DATE);
    END IF;
END;


--------------------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE TRIGGER TRG_PENALTY_CANCEL_AFTER_INS
	AFTER INSERT ON PENALTY_CANCEL
	FOR EACH ROW
DECLARE
BEGIN
    -- 패널티 취소로 상태(계정 정지)에 변경이 발생했다면,
    -- 해당 패널티에 연관된 패널티 상태 레코드 삭제
    -- (별도의 상태 분류가 가능한 컬럼이나 테이블이 없어 삭제로 처리)
    DELETE
    FROM PENALTY_STATUS
    WHERE PENALTY_ID = :NEW.PENALTY_ID;
END;
<<<<<<< HEAD
=======
*/
>>>>>>> 02706d13cfda250fcb449d8a7307b6f65bbc423a
