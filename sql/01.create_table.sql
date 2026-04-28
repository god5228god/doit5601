select user
  from dual;

select *
  from tab;

-- 테이블 생성
-- ○ 1. 회원 고유키 USER
create table users (
   user_id number not null,
   constraint user_user_id_pk primary key ( user_id )
);


-- ○ 2. 회원 계정
create table user_account (
   user_id       number not null,
   user_login_id varchar2(50) not null,
   user_password varchar2(100) not null,
   constraint user_account_user_id_pk primary key ( user_id ),
   constraint user_account_user_id_fk foreign key ( user_id )
      references users ( user_id ),
   constraint user_account_id_uk unique ( user_login_id ),
   constraint user_account_id_ck
      check ( length(user_login_id) between 4 and 12 ),
   constraint user_account_pw_ck
      check ( length(user_password) between 8 and 16 )
);


-- ○ 3. 회원 정보
create table user_profile (
   user_id             number not null,
   user_name           varchar2(50) not null,
   user_ssn            char(13) not null,
   user_email          varchar2(100) not null,
   user_phone          char(11) not null,
   user_zipcode        varchar2(7) not null,
   user_address        varchar2(300) not null,
   user_address_detail varchar2(300) not null,
   constraint user_profile_user_id_pk primary key ( user_id ),
   constraint user_profile_user_id_fk foreign key ( user_id )
      references users ( user_id ),
   constraint user_profile_ssn_uk unique ( user_ssn ),
   constraint user_profile_email_uk unique ( user_email ),
   constraint user_profile_ssn_ck check ( length(user_ssn) = 13 ),
   constraint user_profile_phone_ck
      check ( length(user_phone) between 10 and 11 ),
   constraint user_profile_zipcode_ck
      check ( length(user_zipcode) between 5 and 7 )
);


-- ○ 4. 탈퇴 회원
create table deleted_user (
   user_id             number not null,
   user_name           varchar2(50) not null,
   user_ssn            char(13) not null,
   user_email          varchar2(100) not null,
   user_phone          char(11) not null,
   user_zipcode        varchar2(7) not null,
   user_address        varchar2(300) not null,
   user_address_detail varchar2(300) not null,
   constraint deleted_user_user_id_pk primary key ( user_id ),
   constraint deleted_user_user_id_fk foreign key ( user_id )
      references users ( user_id ),
   constraint deleted_user_ssn_uk unique ( user_ssn ),
   constraint deleted_user_email_uk unique ( user_email ),
   constraint deleted_user_ssn_ck check ( length(user_ssn) = 13 ),
   constraint deleted_user_phone_ck
      check ( length(user_phone) between 10 and 11 ),
   constraint deleted_user_zipcode_ck
      check ( length(user_zipcode) between 5 and 7 )
);


-- ○ 5. 계정 이벤트 분류
create table account_event_type (
   account_event_type_id number not null,
   event_name            varchar2(50) not null,
   constraint account_event_type_account_event_type_id_pk primary key ( account_event_type_id ),
   constraint account_event_type_event_name_uk unique ( event_name )
);


-- ○ 6. 계정 이벤트 이력
create table account_event_history (
   account_event_id      number not null,
   user_id               number not null,
   account_event_type_id number not null,
   created_at            date default sysdate not null,
   constraint account_event_history_account_event_id_pk primary key ( account_event_id ),
   constraint account_event_history_user_id_fk foreign key ( user_id )
      references users ( user_id ),
   constraint account_event_history_account_event_type_id_fk foreign key ( account_event_type_id )
      references account_event_type ( account_event_type_id ),
   constraint account_event_history_user_id_account_event_type_id_uk unique ( user_id,
                                                                              account_event_type_id )
);


-- ○ 7. 관리자 권한 코드
create table admin_role (
   admin_role_id   number not null,
   admin_role_name varchar2(50) not null,
   constraint admin_role_admin_role_id_pk primary key ( admin_role_id ),
   constraint admin_role_admin_role_name_uk unique ( admin_role_name )
);


-- ○ 8. 관리자 계정
create table admin_account (
   admin_account_id number not null,
   admin_role_id    number not null,
   admin_login_id   varchar2(50) not null,
   admin_password   varchar2(100) not null,
   constraint admin_account_admin_account_id_pk primary key ( admin_account_id ),
   constraint admin_account_admin_role_id_fk foreign key ( admin_role_id )
      references admin_role ( admin_role_id ),
   constraint admin_login_id_uk unique ( admin_login_id ),
   constraint admin_account_id_ck
      check ( length(admin_login_id) between 4 and 12 ),
   constraint admin_account_pw_ck
      check ( length(admin_password) between 8 and 16 )
);


-- ○ 9. 관리자 정보
create table admin_profile (
   employee_id   number not null,
   employee_name varchar2(50) not null,
   department    varchar2(50) not null,
   constraint admin_profile_employee_id_pk primary key ( employee_id )
);


-- ○ 10. 관리자 계정 이력
create table admin_account_history (
   admin_history_id   number not null,
   admin_account_id   number not null,
   employee_id        number not null,
   account_start_date date default sysdate not null,
   account_end_date   date null,
   constraint admin_account_history_admin_history_id_pk primary key ( admin_history_id ),
   constraint admin_account_history_admin_account_id_fk foreign key ( admin_account_id )
      references admin_account ( admin_account_id ),
   constraint admin_account_history_employee_id_fk foreign key ( employee_id )
      references admin_profile ( employee_id ),
   constraint admin_account_history_admin_account_id_account_start_date_uk unique ( admin_account_id,
                                                                                    account_start_date )
);


-- 유니크인덱스: 사용중인 계정은 관리자당 하나여야 함
create unique index uix_admin_current_only on
   admin_account_history ( (
      case
         when
            account_end_date
         is null then
               admin_account_id
         else
            null
      end
   ) );



-- ○ 11. 공통 여부 테이블
create table common (
   common_yn_id   number(1) not null,
   common_yn_name char(1) not null,
   constraint common_common_yn_id_pk primary key ( common_yn_id ),
   constraint common_common_yn_name_uk unique ( common_yn_name ),
   constraint common_common_yn_name_ck check ( common_yn_name in ( 'Y',
                                                                   'N' ) )
);



-- ○ 12. 상품 제조국
create table product_country (
   product_country_id   char(2) not null,
   product_country_name varchar2(50) not null,
   constraint product_country_product_country_id_pk primary key ( product_country_id ),
   constraint product_country_name_uk unique ( product_country_name ),
   constraint product_country_id_ck check ( length(product_country_id) = 2 )
);


-- ○ 13. 상품 제조사
create table product_manufacturer (
   manufacturer_id    number not null,
   product_country_id char(2) not null,
   manufacturer_name  varchar2(50) not null,
   constraint product_manufacturer_manufacturer_id_pk primary key ( manufacturer_id ),
   constraint product_manufacturer_product_country_id_fk foreign key ( product_country_id )
      references product_country ( product_country_id ),
   constraint product_manufacturer_product_country_id_manufacturer_name_uk unique ( product_country_id,
                                                                                    manufacturer_name )
);



-- ○ 14. 상품 등급
create table product_grade (
   product_grade_id   number not null,
   product_grade_name varchar2(50) not null,
   constraint product_grade_product_grade_id_pk primary key ( product_grade_id ),
   constraint product_grade_product_grade_name_uk unique ( product_grade_name )
);


-- ○ 15. 상품 장르
create table product_genre (
   product_genre_id   number not null,
   product_genre_name varchar2(50) not null,
   constraint product_genre_product_genre_id_pk primary key ( product_genre_id ),
   constraint product_genre_product_genre_name_uk unique ( product_genre_name )
);


-- ○ 16. 상품 사이즈
create table product_size (
   product_size_id   number not null,
   product_size_name varchar2(10) not null,
   constraint product_size_product_size_id_pk primary key ( product_size_id ),
   constraint product_size_product_size_name_uk unique ( product_size_name )
);


-- ○ 17. 상품 등록/관리
create table product (
   product_id           number not null,
   product_release_name varchar2(500),
   product_alias        varchar2(500),
   user_id              number not null,
   manufacturer_id      number not null,
   product_grade_id     number not null,
   product_genre_id     number not null,
   product_size_id      number not null,
   work_name            varchar2(100),
   character_name       varchar2(100),
   purchase_datetime    date,
   is_opened            number(1) not null,
   is_parts_missing     number(1) not null,
   descriptions         varchar2(2000),
   image_path_1         varchar2(500) not null,
   image_path_2         varchar2(500) not null,
   image_path_3         varchar2(500) not null,
   is_public            number(1) not null,
   created_at           date default sysdate not null,
   constraint product_product_id_pk primary key ( product_id ),
   constraint product_user_id_fk foreign key ( user_id )
      references users ( user_id ),
   constraint product_manufacturer_id_fk foreign key ( manufacturer_id )
      references product_manufacturer ( manufacturer_id ),
   constraint product_product_grade_id_fk foreign key ( product_grade_id )
      references product_grade ( product_grade_id ),
   constraint product_product_genre_id_fk foreign key ( product_genre_id )
      references product_genre ( product_genre_id ),
   constraint product_product_size_id_fk foreign key ( product_size_id )
      references product_size ( product_size_id ),
   constraint product_is_opened_fk foreign key ( is_opened )
      references common ( common_yn_id ),
   constraint product_is_parts_missing_fk foreign key ( is_parts_missing )
      references common ( common_yn_id ),
   constraint product_is_public_fk foreign key ( is_public )
      references common ( common_yn_id )
);




-- ○ 18. 추가 이미지
create table product_image (
   product_image_id number not null,
   product_id       number not null,
   image_order      number(1) not null,
   file_path        varchar2(500) not null,
   created_at       date default sysdate,
   constraint product_image_product_image_id_pk primary key ( product_image_id ),
   constraint product_image_product_id_fk foreign key ( product_id )
      references product ( product_id ),
   constraint product_image_product_id_image_order_uk unique ( product_id,
                                                               image_order )
);


-- ○ 19. 관심 상품
create table product_wishlist (
   wishlist_id number not null,
   user_id     number not null,
   product_id  number not null,
   created_at  date default sysdate not null,
   constraint product_wishlist_wishlist_id_pk primary key ( wishlist_id ),
   constraint product_wishlist_user_id_fk foreign key ( user_id )
      references users ( user_id ),
   constraint product_wishlist_product_id_fk foreign key ( product_id )
      references product ( product_id ),
   constraint product_wishlist_user_id_product_id_uk unique ( user_id,
                                                              product_id )
);


-- ○ 20. 머니 분류
create table money_type (
   money_type_id   number not null,
   money_type_name varchar2(50) not null,
   constraint money_type_money_type_id_pk primary key ( money_type_id ),
   constraint money_type_money_type_name_uk unique ( money_type_name )
);


-- ○ 21. 머니 충전 수단
create table money_charge_method (
   money_charge_method_id   number,
   money_charge_method_name varchar2(50) not null,
   constraint money_charge_method_money_charge_method_id_pk primary key ( money_charge_method_id ),
   constraint money_charge_method_money_charge_method_name_uk unique ( money_charge_method_name )
);

-- ○ 22. 머니 충전 이력
create table money_charge_history (
   money_charge_id        number,
   user_id                number not null,
   money_charge_method_id number not null,
   charge_amount          number not null,
   charged_at             date default sysdate not null,
   constraint money_charge_history_money_charge_id_pk primary key ( money_charge_id ),
   constraint money_charge_history_user_id_fk foreign key ( user_id )
      references users ( user_id ),
   constraint money_charge_history_money_charge_method_id_fk foreign key ( money_charge_method_id )
      references money_charge_method ( money_charge_method_id )
);

-- ○ 23. 경매 기간
create table auction_period (
   auction_period_id   number,
   auction_period_name varchar2(10) not null,
   constraint auction_period_auction_period_id_pk primary key ( auction_period_id ),
   constraint auction_period_auction_period_name_uk unique ( auction_period_name )
);

-- ○ 24. 경매 등록
create table auction_registration (
   auction_id        number,
   product_id        number not null,
   auction_title     varchar2(300) not null,
   auction_content   varchar2(2000) not null,
   start_price       number(12) not null,
   created_at        date default sysdate not null,
   auction_period_id number,
   constraint auction_registration_auction_id_pk primary key ( auction_id ),
   constraint auction_registration_product_id_fk foreign key ( product_id )
      references product ( product_id ),
   constraint auction_registration_auction_period_id_fk foreign key ( auction_period_id )
      references auction_period ( auction_period_id ),
   constraint auction_registration_start_price_ck check ( start_price > 0 )
);


-- ○ 25. 머니 입출금 이력  ← AUCTION_REGISTRATION 이후에 생성
create table money_transaction_history (
   money_id      number,
   user_id       number not null,
   money_type_id number not null,
   auction_id    number,
   amount        number(12) not null,
   created_at    date default sysdate not null,
   constraint money_transaction_history_money_id_pk primary key ( money_id ),
   constraint money_transaction_history_user_id_fk foreign key ( user_id )
      references users ( user_id ),
   constraint money_transaction_history_money_type_id_fk foreign key ( money_type_id )
      references money_type ( money_type_id ),
   constraint money_transaction_history_auction_id_fk foreign key ( auction_id )
      references auction_registration ( auction_id )
);

-- ○ 26. 경매 취소 이력
create table auction_cancel_history (
   auction_cancel_id number,
   auction_id        number not null,
   cancel_reason     varchar2(500) not null,
   cancel_at         date default sysdate not null,
   constraint auction_cancel_history_auction_cancel_id_pk primary key ( auction_cancel_id ),
   constraint auction_cancel_history_auction_id_fk foreign key ( auction_id )
      references auction_registration ( auction_id ),
   constraint auction_cancel_history_auction_id_uk unique ( auction_id )
);

-- ○ 27. 입찰 참여
create table auction_bid_participation (
   bid_id     number,
   auction_id number not null,
   user_id    number not null,
   bid_time   timestamp default systimestamp not null,
   bid_price  number(10) not null,
   constraint auction_bid_participation_bid_id_pk primary key ( bid_id ),
   constraint auction_bid_participation_auction_id_fk foreign key ( auction_id )
      references auction_registration ( auction_id ),
   constraint auction_bid_participation_user_id_fk foreign key ( user_id )
      references users ( user_id ),
   constraint auction_bid_participation_auction_id_user_id_bid_time_uk unique ( auction_id,
                                                                                user_id,
                                                                                bid_time )
);

-- ○ 28. 낙찰 결과
create table auction_winning_result (
   bid_result_id number,
   bid_id        number not null,
   created_at    date default sysdate not null,
   constraint auction_winning_result_bid_result_id_pk primary key ( bid_result_id ),
   constraint auction_winning_result_bid_id_fk foreign key ( bid_id )
      references auction_bid_participation ( bid_id ),
   constraint auction_winning_result_bid_id_uk unique ( bid_id )
);

-- ○ 29. 낙찰 실패 유형
create table bid_failure_type (
   bid_fail_type_id   number,
   bid_fail_type_name varchar2(50) not null,
   constraint bid_failure_type_bid_fail_type_id_pk primary key ( bid_fail_type_id ),
   constraint bid_failure_type_bid_fail_type_name_uk unique ( bid_fail_type_name )
);

-- ○ 30. 낙찰 실패 이력
create table bid_failure_history (
   bid_fail_history_id number,
   bid_result_id       number not null,
   bid_fail_type_id    number not null,
   created_at          date default sysdate not null,
   constraint bid_failure_history_bid_fail_history_id_pk primary key ( bid_fail_history_id ),
   constraint bid_failure_history_bid_result_id_fk foreign key ( bid_result_id )
      references auction_winning_result ( bid_result_id ),
   constraint bid_failure_history_bid_fail_type_id_fk foreign key ( bid_fail_type_id )
      references bid_failure_type ( bid_fail_type_id ),
   constraint bid_failure_history_bid_result_id_uk unique ( bid_result_id )
);

-- ○ 31. 낙찰 입금
create table auction_winning_payment (
   payment_id    number,
   bid_result_id number not null,
   money_id      number not null,
   created_at    date default sysdate not null,
   constraint auction_winning_payment_payment_id_pk primary key ( payment_id ),
   constraint auction_winning_payment_bid_result_id_fk foreign key ( bid_result_id )
      references auction_winning_result ( bid_result_id ),
   constraint auction_winning_payment_money_id_fk foreign key ( money_id )
      references money_transaction_history ( money_id ),
   constraint auction_winning_payment_bid_result_id_uk unique ( bid_result_id )
);

-- ○ 32. 발송 완료
create table delivery_completed (
   shipping_id number,
   payment_id  number not null,
   created_at  date default sysdate not null,
   constraint delivery_completed_shipping_id_pk primary key ( shipping_id ),
   constraint delivery_completed_payment_id_fk foreign key ( payment_id )
      references auction_winning_payment ( payment_id ),
   constraint delivery_completed_payment_id_uk unique ( payment_id )
);



-- ○ 33. 구매 확정 이력
create table purchase_confirm_history (
   purchase_confirm_id number,
   shipping_id         number not null,
   created_at          date default sysdate not null,
   constraint purchase_confirm_history_purchase_confirm_id_pk primary key ( purchase_confirm_id ),
   constraint purchase_confirm_history_shipping_id_fk foreign key ( shipping_id )
      references delivery_completed ( shipping_id )
);

-- ○ 34. 거래 완료
create table transaction_completed (
   transaction_id      number,
   purchase_confirm_id number not null,
   created_at          date default sysdate not null,
   constraint transaction_completed_transaction_id_pk primary key ( transaction_id ),
   constraint transaction_completed_purchase_confirm_id_fk foreign key ( purchase_confirm_id )
      references purchase_confirm_history ( purchase_confirm_id )
);

-- ○ 35. 패널티 부여 구분
create table penalty_assign_type (
   penalty_type_id   number,
   penalty_type_name varchar2(50) not null,
   constraint penalty_assign_type_penalty_assign_type_id_pk primary key ( penalty_type_id ),
   constraint penalty_assign_type_penalty_type_name_uk unique ( penalty_type_name )
);

-- ○ 36. 패널티 이력
create table penalty_history (
   penalty_id       number,
   user_id          number not null,
   penalty_type_id  number not null,
   admin_account_id number,
   penalty_score    number not null,
   created_at       date default sysdate not null,
   constraint penalty_history_penalty_history_id_pk primary key ( penalty_id ),
   constraint penalty_history_user_id_fk foreign key ( user_id )
      references users ( user_id ),
   constraint penalty_history_penalty_type_id_fk foreign key ( penalty_type_id )
      references penalty_assign_type ( penalty_type_id ),
   constraint penalty_history_admin_account_id_fk foreign key ( admin_account_id )
      references admin_account ( admin_account_id ),
   constraint penalty_history_score_ck check ( penalty_score between 1 and 4 )
);


-- ○ 37. 패널티 상태
create table penalty_status (
   penalty_status_id  number,
   penalty_id         number not null,
   penalty_start_date date default sysdate not null,
   penalty_end_date   date not null,
   constraint penalty_status_penalty_status_id_pk primary key ( penalty_status_id ),
   constraint penalty_status_penalty_id_fk foreign key ( penalty_id )
      references penalty_history ( penalty_id )
);

-- ○ 38. 패널티 취소
create table penalty_cancel (
   penalty_cancel_id number,
   penalty_id        number not null,
   admin_account_id  number not null,
   cancel_reason     varchar2(500) not null,
   canceled_at       date default sysdate not null,
   constraint penalty_cancel_penalty_cancel_id_pk primary key ( penalty_cancel_id ),
   constraint penalty_cancel_penalty_id_fk foreign key ( penalty_id )
      references penalty_history ( penalty_id ),
   constraint penalty_cancel_admin_account_id_fk foreign key ( admin_account_id )
      references admin_account ( admin_account_id ),
   constraint penalty_cancel_penalty_id_uk unique ( penalty_id )
);

-- ○ 39. 신고 유형
create table report_type (
   report_type_id   number,
   report_type_name varchar2(50) not null,
   constraint report_type_report_type_id_pk primary key ( report_type_id ),
   constraint report_type_report_type_name_uk unique ( report_type_name )
);

-- ○ 40. 신고 대상
create table report_target (
   report_target_id   number,
   report_target_name varchar2(50) not null,
   constraint report_target_report_target_id_pk primary key ( report_target_id ),
   constraint report_target_report_target_name_uk unique ( report_target_name )
);



-- ○ 41. 신고 신청
create table report_submission (
   report_submission_id number,
   user_id              number not null,
   report_target_id     number not null,
   report_type_id       number not null,
   report_reason        varchar2(500),
   created_at           date default sysdate not null,
   constraint report_submission_report_submission_id_pk primary key ( report_submission_id ),
   constraint report_submission_user_id_fk foreign key ( user_id )
      references users ( user_id ),
   constraint report_submission_report_target_id_fk foreign key ( report_target_id )
      references report_target ( report_target_id ),
   constraint report_submission_report_type_id_fk foreign key ( report_type_id )
      references report_type ( report_type_id )
);

-- ○ 42. 상품 신고
create table product_report (
   product_report_id    number,
   report_submission_id number not null,
   product_id           number not null,
   constraint product_report_product_report_id_pk primary key ( product_report_id ),
   constraint product_report_report_id_fk foreign key ( report_submission_id )
      references report_submission ( report_submission_id ),
   constraint product_report_product_id_fk foreign key ( product_id )
      references product ( product_id )
);

-- ○ 43. 경매 신고
create table auction_report (
   auction_report_id    number,
   report_submission_id number not null,
   auction_id           number not null,
   constraint auction_report_auction_report_id_pk primary key ( auction_report_id ),
   constraint auction_report_report_id_fk foreign key ( report_submission_id )
      references report_submission ( report_submission_id ),
   constraint auction_report_auction_id_fk foreign key ( auction_id )
      references auction_registration ( auction_id )
);

-- ○ 44. 신고 처리 결과
create table report_result (
   report_result_id   number,
   report_result_name varchar2(50) not null,
   constraint report_result_report_result_id_pk primary key ( report_result_id ),
   constraint report_result_report_result_name_uk unique ( report_result_name )
);

-- ○ 45. 신고 처리
create table report_process (
   report_process_id    number,
   report_submission_id number not null,
   admin_account_id     number not null,
   report_result_id     number not null,
   process_reason       varchar2(500) not null,
   processed_at         date default sysdate not null,
   constraint report_process_report_process_id_pk primary key ( report_process_id ),
   constraint report_process_report_id_fk foreign key ( report_submission_id )
      references report_submission ( report_submission_id ),
   constraint report_process_admin_account_id_fk foreign key ( admin_account_id )
      references admin_account ( admin_account_id ),
   constraint report_process_report_result_id_fk foreign key ( report_result_id )
      references report_result ( report_result_id )
);





--CREATE SEQUENCE ==========================================================================

-- 1. USERS 
create sequence users_seq start with 1 increment by 1 nocache;

-- 5. ACCOUNT_EVENT_TYPE
create sequence account_event_type_seq start with 1 increment by 1 nocache;

-- 6. ACCOUNT_EVENT_HISTORY
create sequence account_event_history_seq start with 1 increment by 1 nocache;

-- 7. ADMIN_ROLE 
create sequence admin_role_seq start with 1 increment by 1 nocache;

-- 8. ADMIN_ACCOUNT 
create sequence admin_account_seq start with 1 increment by 1 nocache;

-- 9. ADMIN_PROFILE 
create sequence admin_profile_seq start with 1 increment by 1 nocache;

-- 10. ADMIN_ACCOUNT_HISTORY 
create sequence admin_history_seq start with 1 increment by 1 nocache;

-- 13. PRODUCT_MANUFACTURER 
create sequence manufacturer_seq start with 1 increment by 1 nocache;

-- 14. PRODUCT_GRADE 
create sequence product_grade_seq start with 1 increment by 1 nocache;

-- 15. PRODUCT_GENRE 
create sequence product_genre_seq start with 1 increment by 1 nocache;

-- 16. PRODUCT_SIZE 
create sequence product_size_seq start with 1 increment by 1 nocache;

-- 17. PRODUCT 
create sequence product_seq start with 1 increment by 1 nocache;

-- 18. PRODUCT_IMAGE 
create sequence product_image_seq start with 1 increment by 1 nocache;

-- 19. PRODUCT_WISHLIST 
create sequence wishlist_seq start with 1 increment by 1 nocache;

-- 20. MONEY_TYPE 
create sequence money_type_seq start with 1 increment by 1 nocache;

-- 21. MONEY_CHARGE_METHOD 
create sequence money_charge_method_seq start with 1 increment by 1 nocache;

-- 22. MONEY_CHARGE_HISTORY 
create sequence money_charge_seq start with 1 increment by 1 nocache;

-- 25. MONEY_TRANSACTION_HISTORY 
create sequence money_transaction_seq start with 1 increment by 1 nocache;

-- 23. AUCTION_PERIOD 
create sequence auction_period_seq start with 1 increment by 1 nocache;

-- 24. AUCTION_REGISTRATION 
create sequence auction_seq start with 1 increment by 1 nocache;

-- 26. AUCTION_CANCEL_HISTORY 
create sequence auction_cancel_seq start with 1 increment by 1 nocache;

-- 27. AUCTION_BID_PARTICIPATION 
create sequence bid_seq start with 1 increment by 1 nocache;

-- 28. AUCTION_WINNING_RESULT 
create sequence bid_result_seq start with 1 increment by 1 nocache;

-- 31. AUCTION_WINNING_PAYMENT 
create sequence payment_seq start with 1 increment by 1 nocache;


-- 29. BID_FAILURE_TYPE 
create sequence bid_fail_type_seq start with 1 increment by 1 nocache;

-- 30. BID_FAILURE_HISTORY 
create sequence bid_fail_history_seq start with 1 increment by 1 nocache;

-- 32. DELIVERY_COMPLETED 
create sequence shipping_seq start with 1 increment by 1 nocache;

-- 33. PURCHASE_CONFIRM_HISTORY 
create sequence purchase_confirm_seq start with 1 increment by 1 nocache;

-- 34. TRANSACTION_COMPLETED 
create sequence transaction_seq start with 1 increment by 1 nocache;

-- 35. PENALTY_ASSIGN_TYPE 
create sequence penalty_type_seq start with 1 increment by 1 nocache;

-- 36. PENALTY_HISTORY 
create sequence penalty_seq start with 1 increment by 1 nocache;

-- 37. PENALTY_STATUS 
create sequence penalty_status_seq start with 1 increment by 1 nocache;

-- 38. PENALTY_CANCEL 
create sequence penalty_cancel_seq start with 1 increment by 1 nocache;

-- 39. REPORT_TYPE 
create sequence report_type_seq start with 1 increment by 1 nocache;

-- 40. REPORT_TARGET 
create sequence report_target_seq start with 1 increment by 1 nocache;

-- 41. REPORT_SUBMISSION 
create sequence report_seq start with 1 increment by 1 nocache;

-- 42. PRODUCT_REPORT 
create sequence product_report_seq start with 1 increment by 1 nocache;

-- 43. AUCTION_REPORT 
create sequence auction_report_seq start with 1 increment by 1 nocache;

-- 44. REPORT_RESULT 
create sequence report_result_seq start with 1 increment by 1 nocache;

-- 45. REPORT_PROCESS 
create sequence report_process_seq start with 1 increment by 1 nocache;

--CREATE SEQUENCE ==========================================================================






--DROP SEQUENCE ==========================================================================
drop sequence users_seq;
drop sequence account_event_type_seq;
drop sequence account_event_history_seq;
drop sequence admin_role_seq;
drop sequence admin_account_seq;
drop sequence admin_profile_seq;
drop sequence admin_history_seq;
drop sequence manufacturer_seq;
drop sequence product_grade_seq;
drop sequence product_genre_seq;
drop sequence product_size_seq;
drop sequence product_seq;
drop sequence product_image_seq;
drop sequence wishlist_seq;
drop sequence money_type_seq;
drop sequence money_charge_method_seq;
drop sequence money_charge_seq;
drop sequence money_transaction_seq;
drop sequence auction_period_seq;
drop sequence auction_seq;
drop sequence auction_cancel_seq;
drop sequence bid_seq;
drop sequence bid_result_seq;
drop sequence payment_seq;
drop sequence bid_fail_type_seq;
drop sequence bid_fail_history_seq;
drop sequence shipping_seq;
drop sequence purchase_confirm_seq;
drop sequence transaction_seq;
drop sequence penalty_type_seq;
drop sequence penalty_seq;
drop sequence penalty_status_seq;
drop sequence penalty_cancel_seq;
drop sequence report_type_seq;
drop sequence report_target_seq;
drop sequence report_seq;
drop sequence product_report_seq;
drop sequence auction_report_seq;
drop sequence report_result_seq;
drop sequence report_process_seq;

--DROP SEQUENCE ==========================================================================







--DROP TABLE ==========================================================================

drop table report_process;
drop table report_result;
drop table auction_report;
drop table product_report;
drop table report_submission;
drop table report_target;
drop table report_type;
drop table penalty_cancel;
drop table penalty_status;
drop table penalty_history;
drop table penalty_assign_type;
drop table transaction_completed;
drop table purchase_confirm_history;
drop table delivery_completed;
drop table auction_winning_payment;
drop table bid_failure_history;
drop table bid_failure_type;
drop table auction_winning_result;
drop table auction_bid_participation;
drop table auction_cancel_history;
drop table money_transaction_history;
drop table auction_registration;
drop table auction_period;
drop table money_charge_history;
drop table money_charge_method;
drop table money_type;
drop table product_wishlist;
drop table product_image;
drop table product;
drop table product_size;
drop table product_genre;
drop table product_grade;
drop table product_manufacturer;
drop table product_country;
drop table common;
drop table admin_account_history;
drop table admin_profile;
drop table admin_account;
drop table admin_role;
drop table account_event_history;
drop table account_event_type;
drop table deleted_user;
drop table user_profile;
drop table user_account;
drop table users;

--DROP TABLE ==========================================================================