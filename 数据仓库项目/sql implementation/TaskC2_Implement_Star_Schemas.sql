----------------------------------------------------------------------------
--construct star/snowflake schema
----------------------------------------------------------------------------
--Version 1 High aggregation (Level 2)

--topicDIM
DROP TABLE topicdim;

CREATE TABLE topicdim
    AS
        SELECT
            *
        FROM
            topic;

SELECT
    *
FROM
    topicdim;

--MediaDIM
DROP TABLE mediadim;

CREATE TABLE mediadim
    AS
        SELECT
            *
        FROM
            media_channel;

SELECT
    *
FROM
    mediadim;

--MaritalDIM
DROP TABLE maritaldim;

CREATE TABLE maritaldim
    AS
        SELECT DISTINCT
            person_marital_status
        FROM
            person;

SELECT
    *
FROM
    maritaldim;

--StateDIM
DROP TABLE statedim;

CREATE TABLE statedim
    AS
        SELECT DISTINCT
            address_state
        FROM
            address;

SELECT
    *
FROM
    statedim;

--AgeGroupDIM
DROP TABLE agegroupdim;

CREATE TABLE agedim (
    age_id       VARCHAR(30),
    description  VARCHAR(50)
);

INSERT INTO agedim VALUES (
    'Child',
    '0-16'
);

INSERT INTO agedim VALUES (
    'Young Adults',
    '17-30'
);

INSERT INTO agedim VALUES (
    'Middle-aged Adults',
    '31-45'
);

INSERT INTO agedim VALUES (
    'Old-aged adults',
    '> 45'
);

SELECT
    *
FROM
    agedim;

--OccupationDIM
DROP TABLE occupationdim;

CREATE TABLE occupationdim (
    job VARCHAR(20)
);

INSERT INTO occupationdim VALUES ( 'Student' );

INSERT INTO occupationdim VALUES ( 'Staff' );

INSERT INTO occupationdim VALUES ( 'Community' );

SELECT
    *
FROM
    occupationdim;

--ProgramLengthDIM
DROP TABLE programlengthdim;

CREATE TABLE programlengthdim (
    length_id    VARCHAR(20),
    description  VARCHAR(20)
);

INSERT INTO programlengthdim VALUES (
    'Short Event',
    '< 3 sessions'
);

INSERT INTO programlengthdim VALUES (
    'Medium Event',
    '3 - 6 sessions'
);

INSERT INTO programlengthdim VALUES (
    'Long Event',
    '> 6 sessions'
);

SELECT
    *
FROM
    programlengthdim;

--EventSizeDIM
DROP TABLE eventsizedim;

CREATE TABLE eventsizedim (
    size_id      VARCHAR(20),
    description  VARCHAR(20)
);

INSERT INTO eventsizedim VALUES (
    'Small Event',
    '<=10'
);

INSERT INTO eventsizedim VALUES (
    'Medium Event',
    '11-30'
);

INSERT INTO eventsizedim VALUES (
    'Large Event',
    '>30'
);

SELECT
    *
FROM
    eventsizedim;

--ProgramDIM

DROP TABLE programdim;

CREATE TABLE programdim
    AS
        SELECT
            program_id,
            program_name,
            program_details,
            program_fee,
            program_length,
            program_frequency
        FROM
            program;

SELECT
    *
FROM
    programdim;

--SubscribeTimeDIM
DROP TABLE stimedim;

CREATE TABLE stimedim
    AS
        SELECT DISTINCT
            subscription_date AS s_date
        FROM
            subscription;

DROP TABLE subscribetimedim;

CREATE TABLE subscribetimedim
    AS
        SELECT DISTINCT
            to_char(s_date, 'YYYYMM')      AS subscribetime_id,
            to_char(s_date, 'MM')          AS month,
            to_char(s_date, 'YYYY')        AS year
        FROM
            stimedim;

SELECT
    *
FROM
    subscribetimedim;

--AttendanceTimeDIM
DROP TABLE atimddim;

CREATE TABLE atimedim
    AS
        SELECT DISTINCT
            att_date AS a_date
        FROM
            attendance;

DROP TABLE attendancetimedim;

CREATE TABLE attendancetimedim
    AS
        SELECT DISTINCT
            to_char(a_date, 'YYYYMM')      AS attendancetime_id,
            to_char(a_date, 'MM')          AS month,
            to_char(a_date, 'YYYY')        AS year
        FROM
            atimedim;

SELECT
    *
FROM
    attendancetimedim;

--RegisterTimeDIM
DROP TABLE rtimddim;

CREATE TABLE rtimedim
    AS
        SELECT DISTINCT
            reg_date AS r_date
        FROM
            registration;

DROP TABLE registertimedim;

CREATE TABLE registertimedim
    AS
        SELECT DISTINCT
            to_char(r_date, 'YYYYMM')      AS registertime_id,
            to_char(r_date, 'MM')          AS month,
            to_char(r_date, 'YYYY')        AS year
        FROM
            rtimedim;

SELECT
    *
FROM
    registertimedim;

--InterestFact
DROP TABLE interest_temp;

CREATE TABLE interest_temp
    AS
        SELECT
            p.person_marital_status,
            i.topic_id,
            p.person_age,
            a.address_state,
            p.person_job,
            p.person_id
        FROM
            person           p,
            address          a,
            person_interest  i
        WHERE
                p.person_id = i.person_id
            AND a.address_id = p.address_id;

ALTER TABLE interest_temp ADD (
    age_id  VARCHAR(20),
    job     VARCHAR(20)
);

UPDATE interest_temp
SET
    job = 'Student'
WHERE
    person_job = 'Student';

UPDATE interest_temp
SET
    job = 'Staff'
WHERE
    person_job = 'Staff';
    
UPDATE interest_temp
SET
    job = 'Community'
WHERE
    job IS NULL;

UPDATE interest_temp
SET
    age_id = 'Child'
WHERE
        person_age >= 0
    AND person_age <= 16;

UPDATE interest_temp
SET
    age_id = 'Young Adults'
WHERE
        person_age >= 17
    AND person_age <= 30;

UPDATE interest_temp
SET
    age_id = 'Middle-aged Adults'
WHERE
        person_age >= 31
    AND person_age <= 45;

UPDATE interest_temp
SET
    age_id = 'Old-aged Adults'
WHERE
    person_age > 45;

SELECT
    *
FROM
    interest_temp;

DROP TABLE interestfact;

CREATE TABLE interestfact
    AS
        SELECT
            person_marital_status,
            topic_id,
            age_id,
            address_state,
            job,
            COUNT(*) AS numofpeopleinterested
        FROM
            interest_temp
        GROUP BY
            person_marital_status,
            topic_id,
            age_id,
            address_state,
            job;
SELECT
    *
FROM
    interestfact;
--SubscriptionFact
DROP TABLE subscription_temp;

CREATE TABLE subscription_temp
    AS
        SELECT
            pr.program_id,
            to_char(s.subscription_date, 'YYYYMM') AS subscribetime_id,
            p.person_age,
            a.address_state,
            p.person_marital_status,
            p.person_job,
            s.person_id,
            pr.program_length
        FROM
            person        p,
            address       a,
            subscription  s,
            program       pr
        WHERE
                p.person_id = s.person_id
            AND a.address_id = p.address_id
            AND s.program_id = pr.program_id;

ALTER TABLE subscription_temp ADD (
    length_id  VARCHAR(20),
    job        VARCHAR(20),
    age_id     VARCHAR(50)
);

SELECT
    *
FROM
    subscription_temp;

UPDATE subscription_temp
SET
    age_id = 'Child'
WHERE
        person_age >= 0
    AND person_age <= 16;

UPDATE subscription_temp
SET
    age_id = 'Young Adults'
WHERE
        person_age >= 17
    AND person_age <= 30;

UPDATE subscription_temp
SET
    age_id = 'Middle-aged Adults'
WHERE
        person_age >= 31
    AND person_age <= 45;

UPDATE subscription_temp
SET
    age_id = 'Old-aged Adults'
WHERE
    person_age > 45;

UPDATE subscription_temp
SET
    job = 'Student'
WHERE
    person_job = 'Student';

UPDATE subscription_temp
SET
    job = 'Staff'
WHERE
    person_job = 'Staff';

UPDATE subscription_temp
SET
    job = 'Community'
WHERE
    job IS NULL;

UPDATE subscription_temp
SET
    program_length = substr(program_length, 0, instr(program_length, ' ') - 1);

UPDATE subscription_temp
SET
    length_id = 'Short Event'
WHERE
    program_length < 3;

UPDATE subscription_temp
SET
    length_id = 'Medium Event'
WHERE
        program_length > 3
    AND program_length < 6;

UPDATE subscription_temp
SET
    length_id = 'Long Event'
WHERE
    program_length > 6;

DROP TABLE subscriptionfact;

CREATE TABLE subscriptionfact
    AS
        SELECT
            program_id,
            subscribetime_id,
            age_id,
            address_state,
            person_marital_status,
            job,
            length_id,
            COUNT(DISTINCT person_id) AS numberofpeoplesubscribed
        FROM
            subscription_temp
        GROUP BY
            program_id,
            subscribetime_id,
            age_id,
            address_state,
            person_marital_status,
            job,
            length_id;
SELECT
    *
FROM
    subscriptionfact;
--RegistrationFact
DROP TABLE scd1_registration;

CREATE TABLE scd1_registration
    AS
        SELECT
            reg_id,
            reg_num_of_people_registered,
            reg_date,
            event_id,
            person_id,
            media_id
        FROM
            (
                SELECT
                    reg_id,
                    reg_num_of_people_registered,
                    reg_date,
                    event_id,
                    person_id,
                    media_id,
                    RANK()
                    OVER(PARTITION BY event_id, person_id
                         ORDER BY reg_id DESC
                    ) AS rank
                FROM
                    registration
            ) r
        WHERE
            r.rank = 1; /*if same person register the same event multiple times, we treat the newest registration as the real registration*/ DROP TABLE register_temp;

CREATE TABLE register_temp
    AS
        SELECT
            r.media_id,
            to_char(r.reg_date, 'YYYYMM') AS registertime_id,
            p.person_job,
            e.event_size,
            r.reg_num_of_people_registered
        FROM
            scd1_registration  r,
            person             p,
            event              e
        WHERE
                r.person_id = p.person_id
            AND e.event_id = r.event_id;

ALTER TABLE register_temp ADD (
    size_id  VARCHAR(20),
    job      VARCHAR(20)
);

UPDATE register_temp
SET
    size_id = 'Small Event'
WHERE
    event_size <= 10;

UPDATE register_temp
SET
    size_id = 'Medium Event'
WHERE
        event_size > 10
    AND event_size <= 30;

UPDATE register_temp
SET
    size_id = 'Large Event'
WHERE
    event_size > 30;

UPDATE register_temp
SET
    job = 'Student'
WHERE
    person_job = 'Student';

UPDATE register_temp
SET
    job = 'Staff'
WHERE
    person_job = 'Staff';

UPDATE register_temp
SET
    job = 'Community'
WHERE
    job IS NULL;

DROP TABLE registerfact;

CREATE TABLE registerfact
    AS
        SELECT
            media_id,
            registertime_id,
            job,
            size_id,
            SUM(reg_num_of_people_registered) AS numofpeopleregistered
        FROM
            register_temp
        GROUP BY
            media_id,
            registertime_id,
            job,
            size_id;

SELECT
    *
FROM
    registerfact;

--AttendanceFact
DROP TABLE attendance_temp;

CREATE TABLE attendance_temp
    AS
        SELECT
            pr.program_id,
            to_char(att.att_date, 'YYYYMM') AS attendancetime_id,
            e.event_size,
            pr.program_length,
            p.person_job,
            ad.address_state,
            att.att_num_of_people_attended,
            att.att_donation_amount
        FROM
            program     pr,
            event       e,
            attendance  att,
            person      p,
            address     ad
        WHERE
                pr.program_id = e.program_id
            AND e.event_id = att.event_id
            AND p.person_id = att.person_id
            AND ad.address_id = p.address_id;

SELECT
    *
FROM
    attendance_temp;

ALTER TABLE attendance_temp ADD (
    size_id    VARCHAR(20),
    length_id  VARCHAR(20),
    job        VARCHAR(20)
);

UPDATE attendance_temp
SET
    size_id = 'Small Event'
WHERE
    event_size <= 10;

UPDATE attendance_temp
SET
    size_id = 'Medium Event'
WHERE
        event_size > 10
    AND event_size <= 30;

UPDATE attendance_temp
SET
    size_id = 'Large Event'
WHERE
    event_size > 30;

UPDATE attendance_temp
SET
    program_length = substr(program_length, 0, instr(program_length, ' ') - 1);

UPDATE attendance_temp
SET
    length_id = 'Short Event'
WHERE
    program_length < 3;

UPDATE attendance_temp
SET
    length_id = 'Medium Event'
WHERE
        program_length > 3
    AND program_length < 6;

UPDATE attendance_temp
SET
    length_id = 'Long Event'
WHERE
    program_length > 6;

UPDATE attendance_temp
SET
    job = 'Student'
WHERE
    person_job = 'Student';

UPDATE attendance_temp
SET
    job = 'Staff'
WHERE
    person_job = 'Staff';

UPDATE attendance_temp
SET
    job = 'Community'
WHERE
    job IS NULL;

SELECT
    *
FROM
    attendance_temp;

DROP TABLE attendancefact;

CREATE TABLE attendancefact
    AS
        SELECT
            program_id,
            attendancetime_id,
            size_id,
            length_id,
            job,
            address_state,
            SUM(att_num_of_people_attended)  AS numofpeopleattended,
            SUM(att_donation_amount)         AS totaldonation
        FROM
            attendance_temp
        GROUP BY
            program_id,
            attendancetime_id,
            size_id,
            length_id,
            job,
            address_state;

SELECT
    *
FROM
    attendancefact;
----------------------------------------------------------------------------
--construct star/snowflake schema
----------------------------------------------------------------------------
--Version-2 No aggregation (Level 0)
---dimensions

--persondim
CREATE TABLE persondim
    AS
        SELECT DISTINCT
            person_id
        FROM
            person;

SELECT
    *
FROM
    persondim;

--subscribeDayTimeDIM
DROP TABLE subscribedaytimedim;

CREATE TABLE subscribedaytimedim
    AS
        SELECT DISTINCT
            to_char(subscription_date, 'YYYYMMDD')  AS subscribe_id,
            to_char(subscription_date, 'MM')        AS month,
            to_char(subscription_date, 'YYYY')      AS year,
            to_char(subscription_date, 'DD')        AS day
        FROM
            subscription;

SELECT
    *
FROM
    subscribedaytimedim;
  --registerDayTimeDIM
DROP TABLE registerdaytimedim;

CREATE TABLE registerdaytimedim
    AS
        SELECT DISTINCT
            to_char(reg_date, 'YYYYMMDD')  AS registertime_id,
            to_char(reg_date, 'MM')        AS month,
            to_char(reg_date, 'YYYY')      AS year,
            to_char(reg_date, 'DD')        AS day
        FROM
            registration;

SELECT
    *
FROM
    registerdaytimedim;
    
--attendanceDayTimeDIM
DROP TABLE attendancedaytimedim;

CREATE TABLE attendancedaytimedim
    AS
        SELECT DISTINCT
            to_char(att_date, 'YYYYMMDD')  AS attendancetime_id,
            to_char(att_date, 'MM')        AS month,
            to_char(att_date, 'YYYY')      AS year,
            to_char(att_date, 'DD')        AS day
        FROM
            attendance;

SELECT
    *
FROM
    attendancedaytimedim;
    
-- eventdim
CREATE TABLE eventdim
    AS
        SELECT DISTINCT
            event_id
        FROM
            event;

SELECT
    *
FROM
    eventdim;
    
--attendtypedim
CREATE TABLE attendtypedim (
    attendedtimes VARCHAR(30)
);

INSERT INTO attendtypedim VALUES ( 'first time' );

INSERT INTO attendtypedim VALUES ( 'not first time' );

SELECT
    *
FROM
    attendtypedim;
    
--InterestFact0

SELECT
    *
FROM
    interest_temp;

CREATE TABLE interestfact0
    AS
        SELECT
            person_id,
            person_marital_status,
            topic_id,
            age_id,
            address_state,
            job,
            COUNT(*) AS numofpeopleinterested
        FROM
            interest_temp
        GROUP BY
            person_id,
            person_marital_status,
            topic_id,
            age_id,
            address_state,
            job;

SELECT
    *
FROM
    interestfact0;

--subscriptionfact0
DROP TABLE subscription_temp0;

CREATE TABLE subscription_temp0
    AS
        SELECT
            pr.program_id,
            to_char(s.subscription_date, 'YYYYMMDD') AS subscribetime_id,
            p.person_age,
            a.address_state,
            p.person_marital_status,
            p.person_job,
            s.person_id,
            pr.program_length
        FROM
            person        p,
            address       a,
            subscription  s,
            program       pr
        WHERE
                p.person_id = s.person_id
            AND a.address_id = p.address_id
            AND s.program_id = pr.program_id;

ALTER TABLE subscription_temp0 ADD (
    length_id  VARCHAR(20),
    job        VARCHAR(20),
    age_id     VARCHAR(50)
);

SELECT
    *
FROM
    subscription_temp0;

UPDATE subscription_temp0
SET
    age_id = 'Child'
WHERE
        person_age >= 0
    AND person_age <= 16;

UPDATE subscription_temp0
SET
    age_id = 'Young Adults'
WHERE
        person_age >= 17
    AND person_age <= 30;

UPDATE subscription_temp0
SET
    age_id = 'Middle-aged Adults'
WHERE
        person_age >= 31
    AND person_age <= 45;

UPDATE subscription_temp0
SET
    age_id = 'Old-aged Adults'
WHERE
    person_age > 45;

UPDATE subscription_temp0
SET
    job = 'Student'
WHERE
    person_job = 'Student';

UPDATE subscription_temp0
SET
    job = 'Staff'
WHERE
    person_job = 'Staff';

UPDATE subscription_temp0
SET
    job = 'Community'
WHERE
    job IS NULL;

UPDATE subscription_temp0
SET
    program_length = substr(program_length, 0, instr(program_length, ' ') - 1);

UPDATE subscription_temp0
SET
    length_id = 'Short Event'
WHERE
    program_length < 3;

UPDATE subscription_temp0
SET
    length_id = 'Medium Event'
WHERE
        program_length > 3
    AND program_length < 6;

UPDATE subscription_temp0
SET
    length_id = 'Long Event'
WHERE
    program_length > 6;

DROP TABLE subscriptionfact0;

CREATE TABLE subscriptionfact0
    AS
        SELECT
            person_id,
            program_id,
            subscribetime_id,
            age_id,
            address_state,
            person_marital_status,
            job,
            length_id,
            COUNT(DISTINCT person_id) AS numberofpeoplesubscribed
        FROM
            subscription_temp0
        GROUP BY
            person_id,
            program_id,
            subscribetime_id,
            age_id,
            address_state,
            person_marital_status,
            job,
            length_id;

SELECT
    *
FROM
    subscriptionfact0;

SELECT
    *
FROM
    subscriptionfact0
WHERE
    numberofpeoplesubscribed > 1;

--registerfact0 
DROP TABLE scd1_registration0;

CREATE TABLE scd1_registration0
    AS
        SELECT
            reg_id,
            reg_num_of_people_registered,
            reg_date,
            event_id,
            person_id,
            media_id
        FROM
            (
                SELECT
                    reg_id,
                    reg_num_of_people_registered,
                    reg_date,
                    event_id,
                    person_id,
                    media_id,
                    RANK()
                    OVER(PARTITION BY event_id, person_id
                         ORDER BY reg_id DESC
                    ) AS rank
                FROM
                    registration
            ) r
        WHERE
            r.rank = 1; /*if same person register the same event multiple times, we treat the newest registration as the real registration*/ DROP TABLE register_temp0;

CREATE TABLE register_temp0
    AS
        SELECT
            p.person_id,
            e.event_id,
            r.media_id,
            to_char(r.reg_date, 'YYYYMMDD') AS registertime_id,
            p.person_job,
            e.event_size,
            r.reg_num_of_people_registered
        FROM
            scd1_registration0  r,
            person              p,
            event               e
        WHERE
                r.person_id = p.person_id
            AND e.event_id = r.event_id;

ALTER TABLE register_temp0 ADD (
    size_id  VARCHAR(20),
    job      VARCHAR(20)
);

UPDATE register_temp0
SET
    size_id = 'Small Event'
WHERE
    event_size <= 10;

UPDATE register_temp0
SET
    size_id = 'Medium Event'
WHERE
        event_size > 10
    AND event_size <= 30;

UPDATE register_temp0
SET
    size_id = 'Large Event'
WHERE
    event_size > 30;

UPDATE register_temp0
SET
    job = 'Student'
WHERE
    person_job = 'Student';

UPDATE register_temp0
SET
    job = 'Staff'
WHERE
    person_job = 'Staff';

UPDATE register_temp0
SET
    job = 'Community'
WHERE
    job IS NULL;

DROP TABLE registerfact0;

CREATE TABLE registerfact0
    AS
        SELECT
            person_id,
            event_id,
            media_id,
            registertime_id,
            job,
            size_id,
            SUM(reg_num_of_people_registered) AS numofpeopleregistered
        FROM
            register_temp0
        GROUP BY
            person_id,
            event_id,
            media_id,
            registertime_id,
            job,
            size_id;

SELECT
    *
FROM
    registerfact0;

SELECT
    COUNT(*)
FROM
    registerfact0; /*1412*/ SELECT
    COUNT(*)
FROM
    scd1_registration0; /*1412 two values are the same each which means no aggregation happened */

--attendancefact0
DROP TABLE alterattendance;

CREATE TABLE alterattendance
    AS
        SELECT
            att_id,
            att_date,
            att_donation_amount,
            att_num_of_people_attended,
            event_id,
            person_id,
            rank
        FROM
            (
                SELECT
                    att_id,
                    att_date,
                    att_donation_amount,
                    att_num_of_people_attended,
                    event_id,
                    person_id,
                    RANK()
                    OVER(PARTITION BY event_id, person_id, att_date
                         ORDER BY att_id
                    ) AS rank
                FROM
                    attendance
            );

SELECT
    *
FROM
    alterattendance
WHERE
        event_id = 150
    AND person_id = 'PE005'
    AND att_date = TO_DATE('2020-09-10', 'YYYY-MM-DD');

SELECT
    *
FROM
    alterattendance;

DROP TABLE attendance_temp0;

CREATE TABLE attendance_temp0
    AS
        SELECT
            p.person_id,
            e.event_id,
            pr.program_id,
            to_char(att.att_date, 'YYYYMMDD') AS attendancetime_id,
            e.event_size,
            pr.program_length,
            p.person_job,
            ad.address_state,
            att.att_num_of_people_attended,
            att.att_donation_amount,
            att.rank
        FROM
            program          pr,
            event            e,
            alterattendance  att,
            person           p,
            address          ad
        WHERE
                pr.program_id = e.program_id
            AND e.event_id = att.event_id
            AND p.person_id = att.person_id
            AND ad.address_id = p.address_id;

SELECT
    *
FROM
    attendance_temp0;

ALTER TABLE attendance_temp0 ADD (
    size_id        VARCHAR(20),
    length_id      VARCHAR(20),
    job            VARCHAR(20),
    attendedtimes  VARCHAR(20)
);

UPDATE attendance_temp0
SET
    attendedtimes = 'first time'
WHERE
    rank = 1;

UPDATE attendance_temp0
SET
    attendedtimes = 'not first time'
WHERE
    rank <> 1;

UPDATE attendance_temp0
SET
    size_id = 'Small Event'
WHERE
    event_size <= 10;

UPDATE attendance_temp0
SET
    size_id = 'Medium Event'
WHERE
        event_size > 10
    AND event_size <= 30;

UPDATE attendance_temp0
SET
    size_id = 'Large Event'
WHERE
    event_size > 30;

UPDATE attendance_temp0
SET
    program_length = substr(program_length, 0, instr(program_length, ' ') - 1);

UPDATE attendance_temp0
SET
    length_id = 'Short Event'
WHERE
    program_length < 3;

UPDATE attendance_temp0
SET
    length_id = 'Medium Event'
WHERE
        program_length > 3
    AND program_length < 6;

UPDATE attendance_temp0
SET
    length_id = 'Long Event'
WHERE
    program_length > 6;

UPDATE attendance_temp0
SET
    job = 'Student'
WHERE
    person_job = 'Student';

UPDATE attendance_temp0
SET
    job = 'Staff'
WHERE
    person_job = 'Staff';

UPDATE attendance_temp0
SET
    job = 'Community'
WHERE
    job IS NULL;

SELECT
    *
FROM
    attendance_temp0;

DROP TABLE attendancefact0;

CREATE TABLE attendancefact0
    AS
        SELECT
            person_id,
            event_id,
            attendedtimes,
            program_id,
            attendancetime_id,
            size_id,
            length_id,
            job,
            address_state,
            SUM(att_num_of_people_attended)  AS numofpeopleattended,
            SUM(att_donation_amount)         AS totaldonation
        FROM
            attendance_temp0
        GROUP BY
            person_id,
            event_id,
            attendedtimes,
            program_id,
            attendancetime_id,
            size_id,
            length_id,
            job,
            address_state;

SELECT
    *
FROM
    attendancefact0;
---testtable---
/*create table testtable as
select att.att_id, p.person_id, e.event_id,pr.program_id, to_char(att.att_date, 'YYYYMMDD') as attendanceTime_id, 
e.event_size, pr.program_length, p.person_job, ad.address_state,
att.att_num_of_people_attended, att.att_donation_amount, att.rank
from program pr, event e, alterattendance att, person p, address ad
where pr.program_id = e.program_id
and e.event_id = att.event_id
and p.person_id = att.person_id
and ad.address_id = p.address_id;*/
--select * from attendance where att_id not in (select att_id from testtable);
SELECT
    COUNT(*)
FROM
    attendance; /*5650*/ SELECT
    COUNT(*)
FROM
    attendancefact0; /*5650, the fact table have the same number of rows as the original attendance table. so there is no aggregation happened*/ SELECT
    *
FROM
    attendancefact0;