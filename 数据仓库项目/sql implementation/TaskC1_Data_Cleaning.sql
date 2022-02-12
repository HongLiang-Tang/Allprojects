--Drop all tables

DROP TABLE address;

DROP TABLE attendance;

DROP TABLE event;

DROP TABLE event_marketing;

DROP TABLE follow_up;

DROP TABLE media_channel;

DROP TABLE participant;

DROP TABLE person;

DROP TABLE person_interest;

DROP TABLE program;

DROP TABLE registration;

DROP TABLE subscription;

DROP TABLE topic;

DROP TABLE volunteer;

--View original table records from MonExplore

SELECT
    *
FROM
    monexplore.address;

SELECT
    *
FROM
    monexplore.attendance;

SELECT
    *
FROM
    monexplore.event;

SELECT
    *
FROM
    monexplore.event_marketing;

SELECT
    *
FROM
    monexplore.follow_up;

SELECT
    *
FROM
    monexplore.media_channel;

SELECT
    *
FROM
    monexplore.participant;

SELECT
    *
FROM
    monexplore.person;

SELECT
    *
FROM
    monexplore.person_interest;

SELECT
    *
FROM
    monexplore.program;

SELECT
    *
FROM
    monexplore.registration;

SELECT
    *
FROM
    monexplore.subscription;

SELECT
    *
FROM
    monexplore.topic;

SELECT
    *
FROM
    monexplore.volunteer;
    
--Create local tables from MonExplore

CREATE TABLE address
    AS
        SELECT
            *
        FROM
            monexplore.address;

CREATE TABLE attendance
    AS
        SELECT
            *
        FROM
            monexplore.attendance;

CREATE TABLE event
    AS
        SELECT
            *
        FROM
            monexplore.event;

CREATE TABLE event_marketing
    AS
        SELECT
            *
        FROM
            monexplore.event_marketing;

CREATE TABLE follow_up
    AS
        SELECT
            *
        FROM
            monexplore.follow_up;

CREATE TABLE media_channel
    AS
        SELECT
            *
        FROM
            monexplore.media_channel;

CREATE TABLE participant
    AS
        SELECT
            *
        FROM
            monexplore.participant;

CREATE TABLE person
    AS
        SELECT
            *
        FROM
            monexplore.person;

CREATE TABLE person_interest
    AS
        SELECT
            *
        FROM
            monexplore.person_interest;

CREATE TABLE program
    AS
        SELECT
            *
        FROM
            monexplore.program;

CREATE TABLE registration
    AS
        SELECT
            *
        FROM
            monexplore.registration;

CREATE TABLE subscription
    AS
        SELECT
            *
        FROM
            monexplore.subscription;

CREATE TABLE topic
    AS
        SELECT
            *
        FROM
            monexplore.topic;

CREATE TABLE volunteer
    AS
        SELECT
            *
        FROM
            monexplore.volunteer;

----------------------------------------------------------------------------
--data clean
----------------------------------------------------------------------------
--1 Duplication Problems

---address
SELECT
    address_id,
    COUNT(*)
FROM
    address
GROUP BY
    address_id
HAVING
    COUNT(*) > 1;
    
---attendance
SELECT
    att_id,
    COUNT(*)
FROM
    attendance
GROUP BY
    att_id
HAVING
    COUNT(*) > 1;
    
---event
SELECT
    event_id,
    COUNT(*)
FROM
    event
GROUP BY
    event_id
HAVING
    COUNT(*) > 1;

---event_marketing
SELECT
    event_id,
    media_id,
    COUNT(*)
FROM
    event_marketing
GROUP BY
    event_id,
    media_id
HAVING
    COUNT(*) > 1;

---follow_up
SELECT
    person_id,
    person_id2,
    COUNT(*)
FROM
    follow_up
GROUP BY
    person_id,
    person_id2
HAVING
    COUNT(*) > 1;

---media_channel
SELECT
    media_id,
    COUNT(*)
FROM
    media_channel
GROUP BY
    media_id
HAVING
    COUNT(*) > 1;

---participant
SELECT
    person_id,
    COUNT(*)
FROM
    participant
GROUP BY
    person_id
HAVING
    COUNT(*) > 1;

---person
--PE057, PE078, PE021 have identical duplicate records 
SELECT
    person_id,
    COUNT(*)
FROM
    person
GROUP BY
    person_id
HAVING
    COUNT(*) > 1;

--Before data cleaning
SELECT
    *
FROM
    person;
    
--After data cleaning
DROP TABLE person;

CREATE TABLE person
    AS
        SELECT DISTINCT
            *
        FROM
            monexplore.person;

SELECT
    *
FROM
    person;

---person_interest
SELECT
    person_id,
    topic_id,
    COUNT(*)
FROM
    person_interest
GROUP BY
    person_id,
    topic_id
HAVING
    COUNT(*) > 1;

---program
SELECT
    program_id,
    COUNT(*)
FROM
    program
GROUP BY
    program_id
HAVING
    COUNT(*) > 1;

---registration
SELECT
    reg_id,
    COUNT(*)
FROM
    registration
GROUP BY
    reg_id
HAVING
    COUNT(*) > 1;

---subscription
--SU021, SU243 have identical duplicate records 
SELECT
    subscription_id,
    COUNT(*)
FROM
    subscription
GROUP BY
    subscription_id
HAVING
    COUNT(*) > 1;

--Before data cleaning
SELECT
    *
FROM
    subscription
WHERE
    subscription_id = 'SU021'
    OR subscription_id = 'SU243';

--After data cleaning
DROP TABLE subscription;

CREATE TABLE subscription
    AS
        SELECT DISTINCT
            *
        FROM
            monexplore.subscription;

SELECT
    *
FROM
    subscription
ORDER BY
    subscription_id;

---topic
SELECT
    topic_id,
    COUNT(*)
FROM
    topic
GROUP BY
    topic_id
HAVING
    COUNT(*) > 1;

---volunteer
SELECT
    person_id,
    COUNT(*)
FROM
    volunteer
GROUP BY
    person_id
HAVING
    COUNT(*) > 1;

--2.Relationship Problems

---address -> person
SELECT
    *
FROM
    person
WHERE
    address_id NOT IN (
        SELECT
            address_id
        FROM
            address
    );
    
---topic->person_interest
SELECT
    *
FROM
    person_interest
WHERE
    topic_id NOT IN (
        SELECT
            topic_id
        FROM
            topic
    );
    
---person-> person_interest
SELECT
    *
FROM
    person_interest
WHERE
    person_id NOT IN (
        SELECT
            person_id
        FROM
            person
    );
    
---volunteer -> follow_up
SELECT
    *
FROM
    follow_up
WHERE
    person_id NOT IN (
        SELECT
            person_id
        FROM
            volunteer
    );
    
---participant -> follow_up
SELECT
    *
FROM
    follow_up
WHERE
    person_id2 NOT IN (
        SELECT
            person_id
        FROM
            participant
    );
    
---person -> registration
SELECT
    *
FROM
    registration
WHERE
    person_id NOT IN (
        SELECT
            person_id
        FROM
            person
    );
    
---event -> registration
SELECT
    *
FROM
    registration
WHERE
    event_id NOT IN (
        SELECT
            event_id
        FROM
            event
    );
    
---media_channel-> registration
SELECT
    *
FROM
    registration
WHERE
    media_id NOT IN (
        SELECT
            media_id
        FROM
            media_channel
    );
    
---person ->subscription
SELECT
    *
FROM
    subscription
WHERE
    person_id NOT IN (
        SELECT
            person_id
        FROM
            person
    );
    
---program ->subscription
SELECT
    *
FROM
    subscription
WHERE
    program_id NOT IN (
        SELECT
            program_id
        FROM
            program
    );
    
---topic -> program
SELECT
    *
FROM
    program
WHERE
    topic_id NOT IN (
        SELECT
            topic_id
        FROM
            topic
    );

---program -> event
--PR000 for event_id 31 and PR020 for event_id 101 do not exist
SELECT
    *
FROM
    event
WHERE
    program_id NOT IN (
        SELECT
            program_id
        FROM
            program
    );
/*we can see two records related to the referential integrity violate where event_id = 31 or 101*/
SELECT
    *
FROM
    registration
WHERE
    event_id = 31 or event_id = 101;

/* It is not possible to attend an event of a non-existing program. 
Therefore we delete all relevant data from EVENT, EVENT_MARKETING, ATTENDANCE and REGISTRATION 
where event_id = 31 or event_id = 101.*/

DELETE FROM event
WHERE
    event_id = 31
    OR event_id = 101;

DELETE FROM event_marketing
WHERE
    event_id = 31
    OR event_id = 101;

DELETE FROM attendance
WHERE
    event_id = 31
    OR event_id = 101;

DELETE FROM registration
WHERE
    event_id = 31
    OR event_id = 101;

COMMIT;

SELECT
    *
FROM
    event
ORDER BY
    event_id;

---person -> attendance
SELECT
    *
FROM
    attendance
WHERE
    person_id NOT IN (
        SELECT
            person_id
        FROM
            person
    );

---event->attendance
SELECT
    *
FROM
    attendance
WHERE
    event_id NOT IN (
        SELECT
            event_id
        FROM
            event
    );

---event -> event_marketing
SELECT
    *
FROM
    event_marketing
WHERE
    event_id NOT IN (
        SELECT
            event_id
        FROM
            event
    );

---media_channel -> event_marketing
SELECT
    *
FROM
    event_marketing
WHERE
    media_id NOT IN (
        SELECT
            media_id
        FROM
            media_channel
    );

---person -> volunteer
--PE000 and PE110 do not exist
SELECT
    *
FROM
    volunteer
WHERE
    person_id NOT IN (
        SELECT
            person_id
        FROM
            person
    );

--check for existance in follow_up table
SELECT
    *
FROM
    follow_up;

SELECT
    *
FROM
    follow_up
WHERE
    person_id = 'PE000'
    OR person_id = 'PE110';
/*as there is no record of person_id = PE000 or PE110 in 
another related table(follow_up), we can safely delete these two records*/
DELETE FROM volunteer
WHERE
    person_id = 'PE000'
    OR person_id = 'PE110';

DELETE FROM follow_up
WHERE
    person_id = 'PE000'
    OR person_id = 'PE110';

COMMIT;

---person-> participant
SELECT
    *
FROM
    participant
WHERE
    person_id NOT IN (
        SELECT
            person_id
        FROM
            person
    );

COMMIT;

--Inconsistent Values
SELECT
    *
FROM
    address;

SELECT
    *
FROM
    attendance;
/*select to_char(att_date,'yyyymm') from attendance;*/
SELECT
    *
FROM
    event;

SELECT
    *
FROM
    event_marketing;

SELECT
    *
FROM
    follow_up;

SELECT
    *
FROM
    media_channel; /*pk null*/
SELECT
    *
FROM
    participant;

SELECT
    *
FROM
    person;

SELECT
    *
FROM
    person_interest;

SELECT
    *
FROM
    program;

SELECT
    *
FROM
    registration;

SELECT
    *
FROM
    subscription;

SELECT
    *
FROM
    topic; /*value null*/
SELECT
    *
FROM
    volunteer;

--- 3.Inconsistent Values, incorrect values
----event
--check if cost < 0
SELECT
    *
FROM
    event
WHERE
    event_cost < 0;
--check if size < 0
--Event_id 11 and 47 have event_size < 0
SELECT
    *
FROM
    event
WHERE
    event_size <= 0;

--check records in related table (Registration)
SELECT
    *
FROM
    registration
WHERE
    event_id = 11
    OR event_id = 47;

--After data cleaning
UPDATE event
SET
    event_size = 10
WHERE
    event_id = 11;

UPDATE event
SET
    event_size = 75
WHERE
    event_id = 47;

COMMIT;

--view event table
SELECT
    *
FROM
    event;

--check if event_start_date > event_end_date
--event_id 162 and 163
SELECT
    *
FROM
    event
WHERE
    event_start_date > event_end_date;
--focus on date first
SELECT
    event_id,
    to_char(event_start_date, 'YYYY-MM-DD HH24:MI:SS'),
    to_char(event_end_date, 'YYYY-MM-DD HH24:MI:SS')
FROM
    event
WHERE
    to_char(event_start_date, 'YYYY-MM-DD') > to_char(event_end_date, 'YYYY-MM-DD');

SELECT
    *
FROM
    registration
WHERE
    event_id = 162; /* start = 2020-10-17 09:00:00 end = 2020-09-17 07:00:00*/
SELECT
    *
FROM
    registration
WHERE
    event_id = 163; /* start = 2020-10-18 09:00:00 end = 2020-10-17 11:00:00*/

/*As these records are related to records in registration, 
we cannot delete them. We can assume the inserted value 
are mistakenly reversed, so we need to reverse them back.*/

--After data cleaning
UPDATE event
SET
    event_start_date = event_end_date,
    event_end_date = event_start_date
WHERE
    event_id = 162
    OR event_id = 163;

COMMIT;

SELECT
    event_id,
    to_char(event_start_date, 'YYYY-MM-DD HH24:MI:SS'),
    to_char(event_end_date, 'YYYY-MM-DD HH24:MI:SS')
FROM
    event
WHERE
    event_id = 162
    OR event_id = 163;


/*now focus on time with the same date*/
SELECT
    *
FROM
    event
WHERE
    to_char(event_start_date, 'YYYY-MM-DD HH24:MI:SS') > to_char(event_end_date, 'YYYY-MM-DD HH24:MI:SS');

--view the exact event time
SELECT
    event_id,
    to_char(event_start_date, 'YYYY-MM-DD HH24:MI:SS'),
    to_char(event_end_date, 'YYYY-MM-DD HH24:MI:SS')
FROM
    (
        SELECT
            *
        FROM
            event
        WHERE
            event_start_date > event_end_date
    );
/*It seems the staff mistakenly thought 00:00:00 as 24:00:00. we cannot input 24:00:00 as the last moment of a day, but we can correct it as 23:59:59*/
UPDATE event
SET
    event_end_date = to_date((to_char(event_end_date, 'YYYY-MM-DD')
                              || ' 23:59:59'), 'YYYY-MM-DD HH24:MI:SS')
WHERE
    event_start_date > event_end_date;

SELECT
    event_id,
    to_char(event_start_date, 'YYYY-MM-DD HH24:MI:SS'),
    to_char(event_end_date, 'YYYY-MM-DD HH24:MI:SS')
FROM
    event;
/* now all the date has been corrected*/
COMMIT;

----attendance
--check for money < 0
--att_id 639 and 1001
SELECT
    *
FROM
    attendance
WHERE
    att_donation_amount < 0;
    
--Money cannot be negative value; we correct it to a positive value.
--After data cleaning
UPDATE attendance
SET
    att_donation_amount = 25
WHERE
    att_id = 639;

UPDATE attendance
SET
    att_donation_amount = 5
WHERE
    att_id = 1001;

COMMIT;

--view updated value
SELECT
    *
FROM
    attendance
WHERE
    att_id = 639
    OR att_id = 1001;

--check for number of people < 0
SELECT
    *
FROM
    attendance
WHERE
    att_num_of_people_attended < 0;

----event_marketing
--check for money < 0
SELECT
    *
FROM
    event_marketing
WHERE
    em_cost < 0;
    
----program
--check for money < 0
SELECT
    *
FROM
    program
WHERE
    program_fee < 0;
    
----registration 
--check for number of people attended > event_size
SELECT
    *
FROM
    registration
WHERE
    reg_num_of_people_registered < 0;
-------------------------------------------
SELECT
    a.att_id,
    e.event_id,
    a.att_num_of_people_attended,
    e.event_size
FROM
    attendance  a,
    event       e
WHERE
    a.event_id = e.event_id;

SELECT
    *
FROM
    (
        SELECT
            a.att_id,
            e.event_id,
            a.att_num_of_people_attended,
            e.event_size
        FROM
            attendance  a,
            event       e
        WHERE
            a.event_id = e.event_id
    )
WHERE
    att_num_of_people_attended > event_size;
-------------------------------------------
--- 4. null values
--address
SELECT
    *
FROM
    address
WHERE
    address_id IS NULL;

--attendance
SELECT
    *
FROM
    attendance
WHERE
    att_id IS NULL;

--event
SELECT
    *
FROM
    event
WHERE
    event_id IS NULL;

--event_marketing
SELECT
    *
FROM
    event_marketing
WHERE
    media_id IS NULL
    OR event_id IS NULL;

--follow_up
SELECT
    *
FROM
    follow_up
WHERE
    person_id IS NULL
    OR person_id2 IS NULL;

--participant
SELECT
    *
FROM
    participant
WHERE
    person_id IS NULL;

--person
SELECT
    *
FROM
    person
WHERE
    person_id IS NULL;

--person_interest
SELECT
    *
FROM
    person_interest
WHERE
    person_id IS NULL
    OR topic_id IS NULL;

--program
SELECT
    *
FROM
    program
WHERE
    program_id IS NULL;

--registration
SELECT
    *
FROM
    registration
WHERE
    reg_id IS NULL;

--subscription
SELECT
    *
FROM
    subscription
WHERE
    subscription_id IS NULL;

--topic
SELECT
    *
FROM
    topic
WHERE
    topic_id IS NULL;

--media_channel
SELECT
    *
FROM
    media_channel
WHERE
    media_id IS NULL;

--view media_channel
SELECT
    *
FROM
    media_channel;
    
--After data cleaning
DELETE FROM media_channel
WHERE
    media_id IS NULL;

COMMIT;
---------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--topic_description
SELECT
    *
FROM
    topic
WHERE
    topic_description IS NULL; 
/*there is no program related to topic T010.*/
SELECT
    *
FROM
    program
WHERE
    topic_id = 'T010'; 
 /*but there are two people interested in topic_id T010. 
 We don't have to delete this topic since topic_description is not a pk and it is critical for the person_interest table.
 The topic may be newly created and description is not updated in the system*/
SELECT
    *
FROM
    person_interest
WHERE
    topic_id = 'T010';

--view topic
SELECT
    *
FROM
    topic;
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
---decide scd
SELECT
    event_id,
    person_id,
    COUNT(*)
FROM
    attendance
GROUP BY
    event_id,
    person_id
HAVING
    COUNT(*) > 1;

SELECT
    person_id,
    event_id,
    COUNT(*)
FROM
    registration
GROUP BY
    person_id,
    event_id
HAVING
    COUNT(*) > 1;

SELECT
    *
FROM
    registration
WHERE
        event_id = 128
    AND person_id = 'PE022';

SELECT
    *
FROM
    registration
WHERE
    event_id = 128; /*this event is promoted by MC005,MC004,MC001,MC002 according to the registering person*/

SELECT
    *
FROM
    event_marketing
WHERE
    event_id = 128; /* but this event 128 is only promoted by MC005 and MC004 from event marketing information*/
/*Here, we know that a person can register multiple times due to some reasons, for example, he forgot he registered or he want to change the  original registration by making a new registration*/
/* we also know that there are many mismatch in media_id between table registration and event_marketing. So, it would reasonable for us to assume that people are possibly making mistake in 
filling their registration form by providing the wrong media source, and we cannot figure out from which real media channel this person ackownledged this event. What we do know is that this person
did want to change his registration for that particular event*/ 
/*Nevertheless, here we only care about how this person want to change his registration for a particular event, so we will always take the newest registration as the presented one, so we use SCD1 which
reflection the most updated value as time changes*/
SELECT
    *
FROM
    registration
WHERE
        person_id = 'PE041'
    AND event_id = 152;