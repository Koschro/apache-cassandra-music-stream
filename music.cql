//CASSANDRA ASSIGNMENT KONSTANTINOS CHRONIS BAFT1502
//****************************************************************************************************
CREATE KEYSPACE mss WITH replication = {
'class': 'SimpleStrategy', 'replication_factor':
3} ;

USE mss;

//****************************************************************************************************
//Query 1 - Find user by name
//****************************************************************************************************
CREATE TYPE address (
street text,
city text,
state_or_province text,
postal_code text,
country text
);

CREATE TYPE payment ( 
payment_type text,
date_y text,
cost text
);

CREATE TABLE user_by_name (
username text,
address frozen<address>,
payment frozen<payment>,
playlist set<text>, 
PRIMARY KEY ((username))
) WITH comment = 'Q1. Find user by name';

INSERT INTO user_by_name (username)
VALUES ('Maria');
INSERT INTO user_by_name (username)
VALUES('Mixalis');
INSERT INTO user_by_name (username)
VALUES('Vasiliki');

UPDATE user_by_name SET address = 
{ street: 'Eptanisou 21', city: 'Athens',
state_or_province: 'Attiki', postal_code: '11257',country: 'Greece'} 
WHERE username = 'Vasiliki';

UPDATE user_by_name SET payment = 
{ payment_type: 'Cash', date_y: '2016/5/9',
cost: '50.00'} 
WHERE username = 'Mixalis';

UPDATE user_by_name SET payment = 
{ payment_type: 'Cash', date_y: '2014/4/4',
cost: '150.00'} 
WHERE username = 'Maria';

UPDATE user_by_name SET playlist = {
'playlist1' } 
WHERE username = 'Mixalis';

UPDATE user_by_name SET playlist = playlist +{
'playlist2' } 
WHERE username = 'Mixalis';

UPDATE user_by_name SET playlist = {
'playlist3' } 
WHERE username = 'Maria';

//SELECT * FROM user_by_name;

SELECT address,payment,playlist FROM user_by_name WHERE username = 'Maria';

//****************************************************************************************************
//Query 2 - Find song by name
//****************************************************************************************************
CREATE TABLE song_by_name ( 
songname text,
artists set<text> ,
album_name text, 
year text, 
play_count int, 
song_binary text,
PRIMARY KEY ((songname))
)WITH comment = 'Q2. Find song by name';

INSERT INTO song_by_name (songname,album_name,year,play_count,song_binary)
VALUES ('Numb', 'Numb', '2011', 85000000,'00111101');

INSERT INTO song_by_name (songname,album_name,year,play_count,song_binary)
VALUES ('What I have done', 'Numb', '2011', 100000000,'00101101');

INSERT INTO song_by_name (songname,album_name,year,play_count,song_binary)
VALUES ('Clocks', 'Clocks', '2010', 44000000,'11111101');

UPDATE song_by_name SET artists = {
'Linkin Park' } 
WHERE songname = 'Numb';


UPDATE song_by_name SET artists = {
'Linkin Park' } 
WHERE songname = 'What I have done';

UPDATE song_by_name SET artists = {
'Coldplay' } 
WHERE songname = 'Clocks';

//SELECT * FROM song_by_name;

SELECT artists,album_name,year,play_count FROM song_by_name WHERE songname = 'Clocks';

//****************************************************************************************************
//Query 3 - Find songs played by a user, arranged in reverse chronological order
//****************************************************************************************************
CREATE TABLE songs_by_user (
username text,
songname text,
song_date text, 
PRIMARY KEY ((username),songname)
)WITH comment = 'Q3. Find songs played by a user, arranged in reverse chronological order';

INSERT INTO songs_by_user (username,songname,song_date)
VALUES ('Vasiliki', 'Clocks', '2012/4/3');

INSERT INTO songs_by_user (username,songname,song_date)
VALUES ('Maria', 'Numb', '2014/6/9');

INSERT INTO songs_by_user (username,songname,song_date)
VALUES ('Maria', 'What I have done', '2013/5/4');

INSERT INTO songs_by_user (username,songname,song_date)
VALUES ('Maria', 'Clocks', '2016/8/10');

//SELECT * FROM songs_by_user;

SELECT songname,song_date,writetime(song_date) FROM songs_by_user WHERE username = 'Maria';

//****************************************************************************************************
//Query 4 - Find playlist by name
//****************************************************************************************************
CREATE TABLE playlist_by_name (
playlistname text, 
description text, 
username text, 
songname set<text>,
PRIMARY KEY ((playlistname))
)WITH comment = 'Q4. Find playlist by name';

INSERT INTO playlist_by_name (playlistname,description,username)
VALUES ('playlist1', 'chill playlist', 'Maria');

INSERT INTO playlist_by_name (playlistname,description,username)
VALUES ('playlist1', 'rock playlist', 'Mixalis');

INSERT INTO playlist_by_name (playlistname,description,username)
VALUES ('playlist2', 'rock playlist', 'Maria');

UPDATE playlist_by_name SET songname = {'Clocks'} 
WHERE playlistname = 'playlist1';

UPDATE playlist_by_name SET songname = {'What I have done'} 
WHERE playlistname = 'playlist2';

UPDATE playlist_by_name SET songname = {'Numb','Clocks'} 
WHERE playlistname = 'playlist1';

//SELECT * FROM playlist_by_name;

SELECT username, songname, description FROM playlist_by_name WHERE playlistname = 'playlist1';

//****************************************************************************************************
//Query 5 - Find playlist by genre
//****************************************************************************************************
CREATE TABLE playlist_by_genre (
genre text, 
playlistname text,
description text,
songname set<text>, 
PRIMARY KEY ((genre),playlistname)
)WITH comment = 'Q5. Find playlist by genre';

INSERT INTO playlist_by_genre (genre,playlistname,description)
VALUES ('Rock', 'playlist1' ,'chill playlist');

INSERT INTO playlist_by_genre (genre,playlistname,description)
VALUES ('Pop', 'playlist1' ,'dance playlist');

INSERT INTO playlist_by_genre (genre,playlistname,description)
VALUES ('Rnb', 'playlist1' ,'chill playlist');

INSERT INTO playlist_by_genre (genre,playlistname,description)
VALUES ('Rock', 'playlist2' ,'rock playlist');

UPDATE playlist_by_genre SET songname = {'Clocks'} 
WHERE genre = 'Rock' AND playlistname = 'playlist2';

//SELECT * FROM playlist_by_genre;

SELECT playlistname, description, songname FROM playlist_by_genre WHERE genre = 'Rock';

//****************************************************************************************************
//Query 6 - Find playlist by creator
//****************************************************************************************************
CREATE TABLE playlist_by_user (
playlistname text, 
description text,
username text, 
songname set<text>, 
PRIMARY KEY ((playlistname),username)
)WITH comment = 'Q6. Find playlist by creator';

INSERT INTO playlist_by_user (playlistname,description,username)
VALUES ('playlist1', 'rock playlist', 'Vasiliki');

INSERT INTO playlist_by_user (playlistname,description,username)
VALUES ('playlist2', 'pop playlist', 'Mixalis');

INSERT INTO playlist_by_user (playlistname,description,username)
VALUES ('playlist3', 'rnb playlist', 'Maria');

UPDATE playlist_by_user SET songname = {'Clocks'} 
WHERE playlistname = 'playlist3' AND username = 'Maria';

UPDATE playlist_by_user SET songname = {'What I have done','Numb'} 
WHERE playlistname = 'playlist2' AND username = 'Mixalis';

CREATE INDEX ON playlist_by_user (username);

SELECT playlistname, description, songname FROM playlist_by_user WHERE username = 'Mixalis';

//****************************************************************************************************
//Query 7 - Find the followers of a playlist
//****************************************************************************************************
CREATE TABLE followers_by_playlist (
follower text, 
playlistname text, 
description text, 
PRIMARY KEY ((follower),playlistname)
)WITH comment = 'Q7. Find the followers of a playlist';

INSERT INTO followers_by_playlist (follower,playlistname,description)
VALUES ('Vasiliki','playlist1','rock playlist');

INSERT INTO followers_by_playlist (follower,playlistname,description)
VALUES ('Markos','playlist2','rnb playlist');

INSERT INTO followers_by_playlist (follower,playlistname,description)
VALUES ('Maria','playlist3','alternative playlist');

INSERT INTO followers_by_playlist (follower,playlistname,description)
VALUES ('Maria','playlist1','jazz playlist');

CREATE INDEX ON followers_by_playlist (playlistname);

SELECT follower FROM followers_by_playlist WHERE playlistname = 'playlist1';

//****************************************************************************************************
//Query 8 - Find the followers of a user
//****************************************************************************************************
CREATE TABLE followers_by_user (
follower text, 
username text, 
PRIMARY KEY ((follower),username)
)WITH comment = 'Q8. Find the followers of a user';

INSERT INTO followers_by_user (follower,username)
VALUES ('Maria','Vasiliki');

INSERT INTO followers_by_user (follower,username)
VALUES ('Markos','Vasiliki');

INSERT INTO followers_by_user (follower,username)
VALUES ('Maria','Mixalis');

INSERT INTO followers_by_user (follower,username)
VALUES ('Mixalis','Markos');

CREATE INDEX ON followers_by_user (username);

SELECT follower FROM followers_by_user WHERE username = 'Vasiliki';

//****************************************************************************************************
//Query 9 - Find the songs contained in a playlist
//****************************************************************************************************
SELECT  songname FROM playlist_by_name WHERE playlistname = 'playlist1';

//****************************************************************************************************
//Query 10 - Find how many times a playlist has been played
//****************************************************************************************************
CREATE TABLE count_by_playlist (
playlistname text, 
play_count int, 
PRIMARY KEY ((playlistname))
)WITH comment = 'Q10. Find how many times a playlist has been played';

INSERT INTO count_by_playlist (playlistname,play_count)
VALUES ('playlist1',100000000);

INSERT INTO count_by_playlist (playlistname,play_count)
VALUES ('playlist2',45000000);

INSERT INTO count_by_playlist (playlistname,play_count)
VALUES ('playlist3',48000000);

//SELECT * FROM count_by_playlist;

SELECT play_count AS times_played FROM count_by_playlist WHERE playlistname='playlist1';

//****************************************************************************************************
//Query 11 - Find how many times a song has been played
//****************************************************************************************************
CREATE TABLE count_by_song (
songname text, 
play_count int, 
PRIMARY KEY ((songname))
)WITH comment = 'Q11. Find how many times a song has been played';

INSERT INTO count_by_song (songname,play_count)
VALUES ('Clocks',105000000);

INSERT INTO count_by_song (songname,play_count)
VALUES ('Numb',74000000);

//SELECT * FROM count_by_song;

SELECT play_count AS times_played FROM count_by_song WHERE songname='Numb';

//****************************************************************************************************
//Query 12 - List playlists in decreasing popularity; the popularity of a playlist is
//defined by the number of times it has been played
//****************************************************************************************************
CREATE MATERIALIZED VIEW playlist_rank AS
SELECT play_count FROM count_by_playlist
WHERE playlistname IS NOT NULL
AND play_count IS NOT NULL
PRIMARY KEY ((playlistname),play_count)
WITH CLUSTERING ORDER BY (play_count DESC) 
AND comment = 'Q12. List playlists in decreasing popularity';

SELECT * FROM playlist_rank;


//****************************************************************************************************
//Query 13 - List users in decreasing popularity: the popularity of a user is defined
//by the number of followers
//****************************************************************************************************

CREATE TABLE user_rank (
follower text, 
username text, 
counter_value counter,
PRIMARY KEY ((follower),username)
)WITH comment = 'Q13. List users in decreasing popularity';

UPDATE user_rank
SET counter_value = counter_value + 1
WHERE username ='Vasiliki' AND follower ='Maria';

UPDATE user_rank
SET counter_value = counter_value + 1
WHERE username ='Vasiliki' AND follower ='Kostas';

UPDATE user_rank
SET counter_value = counter_value + 1
WHERE username ='Mixalis' AND follower ='Maria';

UPDATE user_rank
SET counter_value = counter_value + 1
WHERE username ='Maria' AND follower ='Kostas';

UPDATE user_rank
SET counter_value = counter_value + 1
WHERE username ='Vasiliki' AND follower ='Mixalis';


SELECT * FROM user_rank;

SELECT COUNT(*) FROM user_rank WHERE username = 'Vasiliki' ALLOW FILTERING;
SELECT COUNT(*) FROM user_rank WHERE username = 'Mixalis' ALLOW FILTERING;
//****************************************************************************************************

