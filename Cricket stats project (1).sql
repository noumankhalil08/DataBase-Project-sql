create database Cricket_Stats_Management_System
use Cricket_Stats_Management_System

--Team Table
create table Team 
(
    Team_id int not null primary key identity (1,1),	--PK (auto incremented)
    Team_name varchar(100),            
    Team_owner varchar(100),          
    Team_sponsor varchar(100),         
    Captain varchar(100),              
    Head_coach varchar(100)            
);

--view for Team table
create view Team_view as
	select Team_id ,Team_Name ,Team_owner,Team_sponsor,Captain,Head_coach
	from Team;

--Store procedure for Team Table (Include : Insert , Update , Delete , Read)
create procedure sp_Team
@update_insert_read_delete_seeView int , 
@update_insert_read_delete_View int=null ,
@Team_id int =Null, 
@Team_name varchar(50) =NUll, 
@Team_sponsor varchar(50) =NUll , 
@Team_owner varchar(50) =NUll ,
@Caption varchar(50) =NUll ,
@Head_coach varchar(50)= Null
As begin

	Begin Transaction Team_trans
	begin try
	if(@update_insert_read_delete_seeView=0) --Insert on 0
	begin
		insert into Team (Team_name , Team_owner , Team_sponsor , Captain ,Head_coach)
		values 
		(@Team_name,@Team_sponsor,@Team_owner,@Caption,@Head_coach)
		--insert into view Team_view on 1
		if(@update_insert_read_delete_View=1)
		begin
		insert into Team_view (Team_name , Team_owner , Team_sponsor , Captain ,Head_coach)
		values 
		(@Team_name,@Team_sponsor,@Team_owner,@Caption,@Head_coach)
		end
	end

	else if (@update_insert_read_delete_seeView=1) --Update on 1
	begin
		update Team
		set 
		Team_name = isnull(@Team_name, Team_name),
        Team_sponsor = isnull(@Team_sponsor, Team_sponsor),
        Team_owner = isnull(@Team_owner, Team_owner),
        Captain = isnull(@Caption, Captain),
        Head_coach = isnull(@Head_coach, Head_coach)
		where
		Team_id=@Team_id
		--Update on 1 in view
		if(@update_insert_read_delete_View=1)
		begin
		update Team_view
		set
		Team_name = isnull(@Team_name, Team_name),
        Team_sponsor = isnull(@Team_sponsor, Team_sponsor),
        Team_owner = isnull(@Team_owner, Team_owner),
        Captain = isnull(@Caption, Captain),
        Head_coach = isnull(@Head_coach, Head_coach)
		where
		Team_id=@Team_id
		end
	end

	else if (@update_insert_read_delete_seeView=2) --Read on 2
	begin
		select * from Team
	end

	else if (@update_insert_read_delete_seeView=3) --Read base on team id on 3
	begin
		select * from Team
		where Team_id=@Team_id
	end

	else if (@update_insert_read_delete_seeView=4) --Delete base on team id on 4
	begin
		delete from Team
		where Team_id=@Team_id
		--delete from view on 1
		if(@update_insert_read_delete_View=1 and @update_insert_read_delete_View !=null)
		begin
		delete from Team_view
		where Team_id=@Team_id
		end
	end
	
	else if (@update_insert_read_delete_seeView=5)
	begin
		print 'View Table Of Team'
		select * from Team_view
	end

	else
	begin
		print'Please Enter right Option'
	end
		
		commit transaction Team_trans
		print 'commited'
	end try
	begin catch
		
		rollback transaction Team_trans
		print 'error roll backing'
	end catch

End

--trigger of Team
create trigger Team_Trigger on Team
After update , insert , delete 

As begin
	select * from Team
End


--Team_view_Trigger
create trigger Team_view_Trigger
on Team_view
instead of insert, update, delete
as
begin
	print 'View Table Of Team'
    select * from Team_view
end

/* Param of team Procedure
@update(1)_insert(0)_read(2 ,3=base on team id)_delete(4=base on team id)_seeView(5) int , 
@update_insert_read_delete_View (1) int ,
@Team_id int =Null, 
@Team_name varchar(50) =NUll, 
@Team_sponsor varchar(50) =NUll , 
@Team_owner varchar(50) =NUll ,
@Caption varchar(50) =NUll ,
@Head_coach varchar(50)= Null*/

exec sp_Team 0 , 1 ,NULL ,'Quetta Gladiators' , 'JAZZ' , 'Amir Khan' , 'Babar Azam' , 'Shoab Akhter'
EXEC sp_Team 0, 1, null, 'Lahore Qalandars', 'Qatar Lubricants Company', 'Fawad Rana', 'Shaheen Afridi', 'Aaqib Javed';
EXEC sp_Team 0, 1, null, 'Karachi Kings', 'ARY Group', 'Salman Iqbal', 'Imad Wasim', 'Peter Moores';
EXEC sp_Team 0, 1, null, 'Peshawar Zalmi', 'Haier', 'Javed Afridi', 'Babar Azam', 'Darren Sammy';
EXEC sp_Team 0, 1, null, 'Islamabad United', 'Leonine Global', 'Ali Naqvi', 'Shadab Khan', 'Azhar Mahmood';
exec sp_Team 2
EXEC sp_Team 1, 1, 16, null, 'a', null, null, null;


EXEC sp_Team 0, 1, null, ' Zalmi', 'Haier', ' Afridi', ' Azam', ' Sammy';
--exec sp_Team 2

--Player Table
create table Player
(
	P_ID int not null primary key identity(1,1) ,		 --PK (Player id auto incremented)
    PName varchar(50),
    DOB varchar(50),	-- 'YYYY-MM-DD' 
    Left_right_hand varchar(20),	--Bats man is right hanf or left hand
    Nationality varchar(50),	 
    Height float,				 
    Bat_bowl varchar(10)	--Bats man is batter or bowler
);

--player view
create view player_view
as
select P_ID,PName , DOB , Left_right_hand , Nationality , Height ,Bat_bowl
from Player

--procedure for player
create procedure sp_Player
@update_insert_read_delete_seeView int , 
@update_insert_read_delete_View int=null ,
@Player_ID int = Null , 
@PName varchar(50) =NUll, 
@DOB varchar(50) =NUll , 
@Left_right_hand varchar(50) =NUll ,
@Nationality varchar(50) =NUll ,
@Height float= Null,
@Bat_bowl varchar(10)= Null
As begin
Begin Transaction Player_trans
begin try

	if(@update_insert_read_delete_seeView=0) --Insert on 0
	begin
		insert into Player (PName , DOB , Left_right_hand , Nationality , Height ,Bat_bowl )
		values 
		(@PName,@DOB,@Left_right_hand,@Nationality,@Height,@Bat_bowl)
		if(@update_insert_read_delete_View=1)
		begin
			insert into player_view (PName , DOB , Left_right_hand , Nationality , Height ,Bat_bowl)
			values 
			(@PName,@DOB,@Left_right_hand,@Nationality,@Height,@Bat_bowl)
		end
	end

	else if (@update_insert_read_delete_seeView=1) --Update on 1
	begin
		update Player
		set 
		PName = isnull(@PName, PName),
        DOB = isnull(@DOB, DOB),
        Left_right_hand = isnull(@Left_right_hand, Left_right_hand),
        Nationality = isnull(@Nationality, Nationality),
        Height = isnull(@Height, Height),
        Bat_bowl = isnull(@Bat_bowl, Bat_bowl)
		where
		P_ID=@Player_ID

		if(@update_insert_read_delete_View=1)
		begin
		update player_view
		set 
		PName = isnull(@PName, PName),
        DOB = isnull(@DOB, DOB),
        Left_right_hand = isnull(@Left_right_hand, Left_right_hand),
        Nationality = isnull(@Nationality, Nationality),
        Height = isnull(@Height, Height),
        Bat_bowl = isnull(@Bat_bowl, Bat_bowl)
		where
		P_ID=@Player_ID
		end
	end

	else if (@update_insert_read_delete_seeView=2) --Read on 2
	begin
		select * from Player
	end

	else if (@update_insert_read_delete_seeView=3) --Read base on Player id on 3
	begin
		select * from Player
		where P_ID=@Player_ID
	end

	else if (@update_insert_read_delete_seeView=4) --Delete base on Player id on 4
	begin
		delete from Player
		where P_ID=@Player_ID
		if(@update_insert_read_delete_View=1)
		begin
		delete from player_view
		where P_ID=@Player_ID
		end
	end

	else if (@update_insert_read_delete_seeView=5)
	begin
		select * from player_view
	end

	else
	begin
		print'Please Enter right Option'
	end

		commit transaction Player_trans
	end try
	begin catch
		rollback transaction Player_trans
	end catch
End

--Player tigger
create trigger Player_Trigger
on Player
After update , insert , delete 

As begin
	select * from Player
End
--Player_view_Trigger
create trigger Player_view_Trigger
on player_view
instead of update , insert , delete 

As begin
	print 'Player view'
	select * from player_view
End

/*
@update(1)_insert(0)_read(2 ,3=base on team id)_delete(4=base on team id)_seeView(5) int , 
@update_insert_read_delete_View int=null (1) ,
@Player_ID int = Null , 
@PName varchar(50) =NUll, 
@DOB date =NUll , 
@Left_right_hand varchar(50) =NUll ,
@Nationality varchar(50) =NUll ,
@Height float= Null,
@Bat_bowl varchar(10)= Null
*/


exec sp_Player 0, 1, Null, 'Sarfaraz Ahmed', '1987-05-22', 'Right', 'Pakistani', 5.8, 'Bat';
exec sp_Player 0, 1, Null, 'Mohammad Hasnain', '2000-04-05', 'Right', 'Pakistani', 6.2, 'Bowl';
exec sp_Player 0, 1, NULL, 'Naseem Shah', '2003-02-15', 'Right', 'Pakistani', 6.0, 'Bowl';
exec sp_Player 0, 1, NULL, 'Jason Roy', '1990-07-21', 'Right', 'English', 6.0, 'Bat';
exec sp_Player 0, 1, NULL, 'Ben Cutting', '1987-01-30', 'Right', 'Australian', 6.4, 'Allrounder';
exec sp_Player 0, 1, NULL, 'Iftikhar Ahmed', '1990-09-03', 'Right', 'Pakistani', 5.9, 'Bat';
exec sp_Player 0, 1, NULL, 'Ahsan Ali', '1993-12-10', 'Right', 'Pakistani', 5.7, 'Bat';
exec sp_Player 0, 1, NULL, 'Muhammad Nawaz', '1994-03-21', 'Left', 'Pakistani', 5.9, 'Allrounder';
exec sp_Player 0, 1, NULL, 'Sohail Tanvir', '1984-12-12', 'Left', 'Pakistani', 6.3, 'Allrounder';
exec sp_Player 0, 1, NULL, 'Faf du Plessis', '1984-07-13', 'Right', 'South African', 5.11, 'Bat';
exec sp_Player 0, 1, NULL, 'Anwar Ali', '1987-11-25', 'Right', 'Pakistani', 5.9, 'Allrounder';

exec sp_Player 0, 1, NULL, 'Shaheen Afridi', '2000-04-06', 'Left', 'Pakistani', 6.6, 'Bowl';
exec sp_Player 0, 1, NULL, 'Haris Rauf', '1993-11-07', 'Right', 'Pakistani', 6.0, 'Bowl';
exec sp_Player 0, 1, NULL, 'Fakhar Zaman', '1990-04-10', 'Left', 'Pakistani', 5.11, 'Bat';
exec sp_Player 0, 1, NULL, 'David Wiese', '1985-05-18', 'Right', 'Namibian', 6.4, 'Allrounder';
exec sp_Player 0, 1, NULL, 'Rashid Khan', '1998-09-20', 'Right', 'Afghan', 5.6, 'Bowl';
exec sp_Player 0, 1, NULL, 'Hussain Talat', '1996-02-12', 'Left', 'Pakistani', 5.8, 'Bat';
exec sp_Player 0, 1, NULL, 'Kamran Ghulam', '1995-10-10', 'Right', 'Pakistani', 5.11, 'Bat';
exec sp_Player 0, 1, NULL, 'Phil Salt', '1996-08-28', 'Right', 'English', 5.11, 'Bat';
exec sp_Player 0, 1, NULL, 'Sikandar Raza', '1986-04-24', 'Right', 'Zimbabwean', 5.11, 'Allrounder';
exec sp_Player 0, 1, NULL, 'Abdullah Shafique', '1999-11-20', 'Right', 'Pakistani', 5.9, 'Bat';
exec sp_Player 0, 1, NULL, 'Zaman Khan', '2002-09-26', 'Right', 'Pakistani', 5.10, 'Bowl';

exec sp_Player 2
--Batting Stats Table
create table Batting_Stats 
(
    Bat_ID int not null primary key identity(1,1),	--PK (Batting stats id)   
	--Foregin keys
    P_ID int foreign key references Player(P_ID), --FK (Player id) 
    Player_Team_ID int foreign key references Team (Team_ID), --FK (Team id)

    Bat_avg float,	-- Batting Average
    Bat_SR float,	-- Batting Strike Rate
    Runs int,	
    Fours int,                        
    Sixes int,                        
    HS int,		-- Highest Score
    Matches int,	-- Number of Matches played
    hundres int,                      
    fifties int,
);
--view of player ,team and bat_stat
create view player_team_batStat_view as 
select	Bat_ID,BS.P_ID, BS.Player_Team_ID,Bat_avg,Bat_SR,Runs,Fours,Sixes,HS,Matches,hundres,fifties,
		PName , DOB , Left_right_hand , Nationality , Height ,Bat_bowl,
		Team_Name ,Team_owner,Team_sponsor,Captain,Head_coach
from Batting_Stats BS
full join Player P
on BS.P_ID=P.P_ID
full join Team T
on BS.Player_Team_ID=T.Team_id

--view of batt_stat
create view bat_stat_view as
select Bat_ID,BS.P_ID, BS.Player_Team_ID,Bat_avg,Bat_SR,Runs,Fours,Sixes,HS,Matches,hundres,fifties
from Batting_Stats BS

--procedure for batting stats
alter procedure sp_battingStats
@update_insert_read_delete_seeView int ,
@update_insert_read_delete_view int =null,  
@Bat_ID int = Null , 
@P_ID int = NULL,
@Player_Team_ID int =Null,
@Bat_avg float=Null,
@Bat_SR float=Null,
@Run int =NUll, 
@Fours int=NUll , 
@Sixes int =NUll ,
@HighestScore int =NUll ,
@Matches int= Null,
@hundres int= Null,
@fifties int =Null
As begin
Begin Transaction battingStats_trans
begin try
	if(@update_insert_read_delete_seeView=0) --Insert on 0
	begin
		insert into Batting_Stats (P_ID, Player_Team_ID,Bat_avg , Bat_SR ,Runs,Fours,Sixes,HS,Matches,hundres,fifties )
		values 
		(@P_ID, @Player_Team_ID, @Bat_avg ,@Bat_SR ,@Run , @Fours  , @Sixes ,@HighestScore ,@Matches ,@hundres ,@fifties)
		if(@update_insert_read_delete_view=1) --Insert on 1 in view
			begin
			insert into bat_stat_view (P_ID, Player_Team_ID,Bat_avg , Bat_SR ,Runs,Fours,Sixes,HS,Matches,hundres,fifties )
			values 
			(@P_ID, @Player_Team_ID, @Bat_avg ,@Bat_SR ,@Run , @Fours  , @Sixes ,@HighestScore ,@Matches ,@hundres ,@fifties)
		end
	end

	else if (@update_insert_read_delete_seeView=1) --Update on 1
	begin
	if @Bat_ID is not NUll	 --if (@P_ID  is not null AND @Player_Team_ID is not null AND @Bat_ID is not NUll)
		begin
			update Batting_Stats
			set 
			P_ID=isnull(@P_ID,P_ID),
			Player_Team_ID=isnull(@Player_Team_ID,Player_Team_ID),
			Bat_avg = isnull(@Bat_avg, Bat_avg),
			Bat_SR = isnull(@Bat_SR, Bat_SR),
			Runs = isnull(@Run, Runs),
			Fours = isnull(@Fours, Fours),
			Sixes = isnull(@Sixes, Sixes),
			HS = isnull(@HighestScore, HS),
			Matches = isnull(@Matches, Matches),
			hundres = isnull(@hundres, hundres),
			fifties = isnull(@fifties, fifties)
			where
			Bat_ID=@Bat_ID
			if(@update_insert_read_delete_view=1) --update on 1 in view 
			begin
			update bat_stat_view
			set
			P_ID=isnull(@P_ID,P_ID),
			Player_Team_ID=isnull(@Player_Team_ID,Player_Team_ID),
			Bat_avg = isnull(@Bat_avg, Bat_avg),
			Bat_SR = isnull(@Bat_SR, Bat_SR),
			Runs = isnull(@Run, Runs),
			Fours = isnull(@Fours, Fours),
			Sixes = isnull(@Sixes, Sixes),
			HS = isnull(@HighestScore, HS),
			Matches = isnull(@Matches, Matches),
			hundres = isnull(@hundres, hundres),
			fifties = isnull(@fifties, fifties)
			where
			Bat_ID=@Bat_ID
			end
		end
		if(@P_ID!=null AND @Player_Team_ID=null)
		begin
			update Batting_Stats
			set
			P_ID=isnull(@P_ID,P_ID),
			Player_Team_ID=isnull(@Player_Team_ID,Player_Team_ID),
			Bat_avg = isnull(@Bat_avg, Bat_avg),
			Bat_SR = isnull(@Bat_SR, Bat_SR),
			Runs = isnull(@Run, Runs),
			Fours = isnull(@Fours, Fours),
			Sixes = isnull(@Sixes, Sixes),
			HS = isnull(@HighestScore, HS),
			Matches = isnull(@Matches, Matches),
			hundres = isnull(@hundres, hundres),
			fifties = isnull(@fifties, fifties)
			where
			P_ID=@P_ID
			if(@update_insert_read_delete_view=1) --Update on 1 in view
			begin
			update bat_stat_view
			set
			P_ID=isnull(@P_ID,P_ID),
			Player_Team_ID=isnull(@Player_Team_ID,Player_Team_ID),
			Bat_avg = isnull(@Bat_avg, Bat_avg),
			Bat_SR = isnull(@Bat_SR, Bat_SR),
			Runs = isnull(@Run, Runs),
			Fours = isnull(@Fours, Fours),
			Sixes = isnull(@Sixes, Sixes),
			HS = isnull(@HighestScore, HS),
			Matches = isnull(@Matches, Matches),
			hundres = isnull(@hundres, hundres),
			fifties = isnull(@fifties, fifties)
			where
			P_ID=@P_ID
			end
		end
		else if (@P_ID=null AND @Player_Team_ID!=null)
		begin
			update Batting_Stats
			set
			P_ID=isnull(@P_ID,P_ID),
			Player_Team_ID=isnull(@Player_Team_ID,Player_Team_ID),
			Bat_avg = isnull(@Bat_avg, Bat_avg),
			Bat_SR = isnull(@Bat_SR, Bat_SR),
			Runs = isnull(@Run, Runs),
			Fours = isnull(@Fours, Fours),
			Sixes = isnull(@Sixes, Sixes),
			HS = isnull(@HighestScore, HS),
			Matches = isnull(@Matches, Matches),
			hundres = isnull(@hundres, hundres),
			fifties = isnull(@fifties, fifties)
			where
			Player_Team_ID=@Player_Team_ID
			if(@update_insert_read_delete_view=1) --update on 1 in view 
			begin
			update bat_stat_view
			set
			P_ID=isnull(@P_ID,P_ID),
			Player_Team_ID=isnull(@Player_Team_ID,Player_Team_ID),
			Bat_avg = isnull(@Bat_avg, Bat_avg),
			Bat_SR = isnull(@Bat_SR, Bat_SR),
			Runs = isnull(@Run, Runs),
			Fours = isnull(@Fours, Fours),
			Sixes = isnull(@Sixes, Sixes),
			HS = isnull(@HighestScore, HS),
			Matches = isnull(@Matches, Matches),
			hundres = isnull(@hundres, hundres),
			fifties = isnull(@fifties, fifties)
			where
			Player_Team_ID=@Player_Team_ID
			end
		end

		

	end

	else if (@update_insert_read_delete_seeView=2) --Read on 2
	begin
		select * from Batting_Stats
	end

	else if (@update_insert_read_delete_seeView=3)  --Read based on team ID ,player id or bat stat id on 3
	begin

		if(@P_ID!=null AND @Player_Team_ID=null)
		begin
			select * from Batting_Stats
			where 
			P_ID=@P_ID

		end

		else if(@P_ID=null AND @Player_Team_ID!=null)
		begin
			select * from Batting_Stats
			where 
			Player_Team_ID=@Player_Team_ID
		end

		else
		begin
			select * from Batting_Stats
			where Bat_ID=@Bat_ID
		end
	end


	else if (@update_insert_read_delete_seeView=4) --Delete base on bat stat id ,team id or player id on 4
	begin
		if(@P_ID!=null AND @Player_Team_ID=null)
		begin
			delete from Batting_Stats
			where P_ID=@P_ID
			if(@update_insert_read_delete_view=1) --delete from view 
			begin
				delete from bat_stat_view
				where P_ID=@P_ID
			end
		end

		else if(@P_ID=null AND @Player_Team_ID!=null)
		begin
			delete from Batting_Stats
			where Player_Team_ID=@Player_Team_ID
			if(@update_insert_read_delete_view=1) --delete from view 
			begin
				delete from bat_stat_view
				where Player_Team_ID=@Player_Team_ID
			end
		end

		else
		begin
			delete from Batting_Stats
			where Bat_ID=@Bat_ID
			if(@update_insert_read_delete_view=1) ---delete from view 
			begin
				delete from bat_stat_view
				where Bat_ID=@Bat_ID
			end
		end
		
	end
	else if (@update_insert_read_delete_seeView=5)
	begin
		select * from bat_stat_view
	end

	else
	begin
		print'Please Enter right Option'
	end

	commit transaction battingStats_trans
	end try
	begin catch
		rollback transaction battingStats_trans
	end catch
End
 
--Batting_Stats tigger
create trigger Batting_Stats_Trigger
on Batting_Stats
After update , insert , delete 

As begin
	select * from Batting_Stats
End
--Batting_Stats_view_Trigger
create trigger Batting_Stats_view_Trigger
on bat_stat_view
instead of update , insert , delete 

As begin
	select * from bat_stat_view
End



/*
@update_insert_read_delete_seeView int ,
@update_insert_read_delete_view int =null,  
@Bat_ID int = Null , 
@P_ID int = NULL,
@Player_Team_ID int =Null,
@Bat_avg float=Null,
@Bat_SR float=Null,
@Run int =NUll, 
@Fours int=NUll , 
@Sixes int =NUll ,
@HighestScore int =NUll ,
@Matches int= Null,
@hundres int= Null,
@fifties int =Null*/

exec sp_battingStats 2

exec sp_battingStats 0,1,Null, 1, 1, 42.5, 137.5, 520, 50, 25, 104, 12, 1, 4 
exec sp_battingStats 0,1, NULL,2, 1, 35.6, 129.0, 450, 40, 20, 92, 10, 0, 3 
exec sp_battingStats 0,1, null, 5, 1, 30.8, 125.5, 370, 35, 18, 85, 14, 2, 2

exec sp_battingStats 0,1, null, 6, 12, 40.2, 132.4, 510, 48, 22, 101, 11, 2, 4; 
exec sp_battingStats 0,1, NULL, 7, 12, 33.3, 126.8, 400, 30, 15, 88, 9, 1, 2; 
exec sp_battingStats 0,1, NULL, 8, 12, 28.9, 122.3, 330, 25, 12, 76, 8, 0, 1; 

create table Bowling_Stats 
(
    Bowl_id int not null primary key identity(1,1),	--PK (Bowling stats id)
    Best_bowl_avg float,	-- Best Bowling Average
    Best_bowl_SR float,		-- Best Bowling Strike Rate
    Econ float,		-- Economy Rate
    Wickets int,                       
    Hattric int,                       
    Five_wickets int,	-- Number of 5-wicket taken
    Best_figures int,	-- Best Bowling Figures

    --Foregin keys
    P_ID int foreign key references Player(P_ID), --FK (Player id) 
    Player_Team_ID int foreign key references Team (Team_ID) --FK (Team id)
);
--view of player ,team and bowl_stat
create view player_team_bowlStat_view as 
select	Bowl_id,BS.P_ID, BS.Player_Team_ID,Best_bowl_avg,Best_bowl_SR,Econ,Wickets,Hattric,Five_wickets,Best_figures,
		PName , DOB , Left_right_hand , Nationality , Height ,Bat_bowl,
		Team_Name ,Team_owner,Team_sponsor,Captain,Head_coach
from Bowling_Stats BS
full join Player P
on BS.P_ID=P.P_ID
full join Team T
on BS.Player_Team_ID=T.Team_id

--view of bowl_stat
create view bowl_stat_view as
select Bowl_id,BS.P_ID, BS.Player_Team_ID,Best_bowl_avg,Best_bowl_SR,Econ,Wickets,Hattric,Five_wickets,Best_figures
from Bowling_Stats BS
--bowling stas procdure
create procedure sp_bowlingstats
    @update_insert_read_delete_Seeview int,
    @update_insert_read_delete_view int=null,
    @Bowl_ID int = null,
    @P_ID int = null,
    @Player_Team_ID int = null,
    @Best_bowl_avg float = null,
    @Best_bowl_SR float = null,
    @Econ float = null,
    @Wickets int = null,
    @Hattric int = null,
    @Five_wickets int = null,
    @Best_figures int = null
as
begin
Begin Transaction bowlingstats_trans
begin try

    if (@update_insert_read_delete_Seeview = 0) -- insert on 0
    begin
        insert into bowling_stats (P_ID, Player_Team_ID, Best_bowl_avg, Best_bowl_SR, Econ, Wickets, Hattric, Five_wickets, Best_figures)
        values (@P_ID, @Player_Team_ID, @Best_bowl_avg, @Best_bowl_SR, @Econ, @Wickets, @Hattric, @Five_wickets, @Best_figures)
		if (@update_insert_read_delete_view = 1) -- insert on 1 in view
		begin
			insert into bowl_stat_view (P_ID, Player_Team_ID, Best_bowl_avg, Best_bowl_SR, Econ, Wickets, Hattric, Five_wickets, Best_figures)
			values (@P_ID, @Player_Team_ID, @Best_bowl_avg, @Best_bowl_SR, @Econ, @Wickets, @Hattric, @Five_wickets, @Best_figures)
		end
    end

    else if (@update_insert_read_delete_Seeview = 1) -- update on 1
    begin

        if (@P_ID is not null and @Player_Team_ID is null)
        begin
            update bowling_stats
            set 
				Player_Team_ID=isnull(@Player_Team_ID,Player_Team_ID),
                Best_bowl_avg = isnull(@Best_bowl_avg, Best_bowl_avg),
                Best_bowl_SR = isnull(@Best_bowl_SR, Best_bowl_SR),
                Econ = isnull(@Econ, Econ),
                Wickets = isnull(@Wickets, Wickets),
                Hattric = isnull(@Hattric, Hattric),
                Five_wickets = isnull(@Five_wickets, Five_wickets),
                Best_figures = isnull(@Best_figures, Best_figures)
            where P_ID = @P_ID
			if (@update_insert_read_delete_view = 1) -- update in view
			begin
				update bowl_stat_view
            set 
				Player_Team_ID=isnull(@Player_Team_ID,Player_Team_ID),
                Best_bowl_avg = isnull(@Best_bowl_avg, Best_bowl_avg),
                Best_bowl_SR = isnull(@Best_bowl_SR, Best_bowl_SR),
                Econ = isnull(@Econ, Econ),
                Wickets = isnull(@Wickets, Wickets),
                Hattric = isnull(@Hattric, Hattric),
                Five_wickets = isnull(@Five_wickets, Five_wickets),
                Best_figures = isnull(@Best_figures, Best_figures)
            where P_ID = @P_ID
			end
        end

        else if (@P_ID is null and @Player_Team_ID is not null)
        begin
            update bowling_stats
            set
				P_ID=isnull(@P_ID,P_ID),
                Best_bowl_avg = isnull(@Best_bowl_avg, Best_bowl_avg),
                Best_bowl_SR = isnull(@Best_bowl_SR, Best_bowl_SR),
                Econ = isnull(@Econ, Econ),
                Wickets = isnull(@Wickets, Wickets),
                Hattric = isnull(@Hattric, Hattric),
                Five_wickets = isnull(@Five_wickets, Five_wickets),
                Best_figures = isnull(@Best_figures, Best_figures)
            where Player_Team_ID = @Player_Team_ID
			if (@update_insert_read_delete_view = 1) -- update in view
			begin
				update bowl_stat_view
            set 
				Player_Team_ID=isnull(@Player_Team_ID,Player_Team_ID),
                Best_bowl_avg = isnull(@Best_bowl_avg, Best_bowl_avg),
                Best_bowl_SR = isnull(@Best_bowl_SR, Best_bowl_SR),
                Econ = isnull(@Econ, Econ),
                Wickets = isnull(@Wickets, Wickets),
                Hattric = isnull(@Hattric, Hattric),
                Five_wickets = isnull(@Five_wickets, Five_wickets),
                Best_figures = isnull(@Best_figures, Best_figures)
            where Player_Team_ID = @Player_Team_ID
			end
        end

        else
        begin
            update bowling_stats
            set 
				P_ID=isnull(@P_ID,P_ID),
				Player_Team_ID=isnull(@Player_Team_ID,Player_Team_ID),
                Best_bowl_avg = isnull(@Best_bowl_avg, Best_bowl_avg),
                Best_bowl_SR = isnull(@Best_bowl_SR, Best_bowl_SR),
                Econ = isnull(@Econ, Econ),
                Wickets = isnull(@Wickets, Wickets),
                Hattric = isnull(@Hattric, Hattric),
                Five_wickets = isnull(@Five_wickets, Five_wickets),
                Best_figures = isnull(@Best_figures, Best_figures)
            where Bowl_ID = @Bowl_ID
			if (@update_insert_read_delete_view = 1) -- update in view
			begin
				update bowl_stat_view
            set 
				Player_Team_ID=isnull(@Player_Team_ID,Player_Team_ID),
                Best_bowl_avg = isnull(@Best_bowl_avg, Best_bowl_avg),
                Best_bowl_SR = isnull(@Best_bowl_SR, Best_bowl_SR),
                Econ = isnull(@Econ, Econ),
                Wickets = isnull(@Wickets, Wickets),
                Hattric = isnull(@Hattric, Hattric),
                Five_wickets = isnull(@Five_wickets, Five_wickets),
                Best_figures = isnull(@Best_figures, Best_figures)
            where Bowl_ID = @Bowl_ID
			end
        end
	end

    else if (@update_insert_read_delete_Seeview = 2) -- read on 2
    begin
        select * from bowling_stats
    end

    else if (@update_insert_read_delete_Seeview = 3) -- read based on team id, player id, or bowl stat id on 3
    begin
        if (@P_ID is not null and @Player_Team_ID is null)
        begin
            select * from bowling_stats
            where P_ID = @P_ID
        end
        else if (@P_ID is null and @Player_Team_ID is not null)
        begin
            select * from bowling_stats
            where Player_Team_ID = @Player_Team_ID
        end
        else
        begin
            select * from bowling_stats
            where Bowl_ID = @Bowl_ID
        end
    end

    else if (@update_insert_read_delete_Seeview = 4) -- delete based on bowl_id, player_team_id, or p_id on 4
    begin
        if (@P_ID is not null and @Player_Team_ID is null)
        begin
            delete from bowling_stats
            where P_ID = @P_ID
			if (@update_insert_read_delete_view = 1)
			begin
				delete from bowl_stat_view
				where P_ID = @P_ID
			end
        end
        else if (@P_ID is null and @Player_Team_ID is not null)
        begin
            delete from bowling_stats
            where Player_Team_ID = @Player_Team_ID
			if (@update_insert_read_delete_view = 1)
			begin
				delete from bowl_stat_view
				where Player_Team_ID = @Player_Team_ID
			end
        end
        else
        begin
            delete from bowling_stats
            where Bowl_ID = @Bowl_ID
			if (@update_insert_read_delete_view = 1)
			begin
				delete from bowl_stat_view
				where Bowl_ID = @Bowl_ID
			end
        end
    end
	else if(@update_insert_read_delete_Seeview=5) 
	begin 
		select * from bowl_stat_view
	end 
	else if (@update_insert_read_delete_Seeview=6)
	begin
		select * from player_team_bowlStat_view
	end
    else
    begin
        print 'please enter the correct option'
    end

	commit transaction bowlingstats_trans
	end try
	begin catch
		rollback transaction bowlingstats_trans
	end catch
end
--bowling_stats_trigger 
create trigger bowling_stats_trigger
on bowling_stats
after insert, update, delete
as
begin
    select * from bowling_stats
end
--bowling_stats_view_trigger
create trigger bowling_stats_view_trigger
on bowl_stat_view
instead of insert, update, delete
as
begin
    select * from bowl_stat_view
end

/*
 @update(1)_insert(0)_read(2 ,3=base on team id)_delete(4=base on team id)_seeView(5) int , 
    @Bowl_ID INT = NULL,
    @P_ID INT = NULL,
    @Player_Team_ID INT = NULL,
    @Best_bowl_avg FLOAT = NULL,
    @Best_bowl_SR FLOAT = NULL,
    @Econ FLOAT = NULL,
    @Wickets INT = NULL,
    @Hattric INT = NULL,
    @Five_wickets INT = NULL,
    @Best_figures INT = NULL
*/
exec sp_bowlingStats 0,1,1,1,89.2,30.6,2.1,5,4,0,3
exec sp_bowlingStats 2


exec sp_bowlingStats 0,1,null, 14, 1, null, null, null, 20, 0, 2, 6;
exec sp_bowlingStats 0, 1,NULL, 15, 1, null, null, null, 18, 0, 1, 4;
exec sp_bowlingStats 0,1 ,NULL, 18, 1, null, null, null, 25, 1, 3, 5;



exec sp_bowlingStats 0, 1,NULL, 2, 12, null, null, null, 15, 0, 0, 3;
exec sp_bowlingStats 0, 1,NULL, 5, 12, null, null, null, 20, 0, 1, 4;
exec sp_bowlingStats 0, 1,NULL, 22, 12, null, null, null, 12, 0, 0, 2;


--Points table
create table Points_table
(
	PT_ID int not null primary key identity(1,1),	--PK (Points table id)
	Win varchar(50),  --Win matches
	Loss varchar(50),  --Lost matches
	Net_run_rate float,		--Total run rate
	Matches_played varchar(50),
	Points int, --Team total point

	--Foreign key
	Team_ID int foreign key references Team(Team_id) 	--FK (Team id)
);
--view and join of point table
create view Team_AND_point_table_view
as
select PT.PT_ID, PT.Win, PT.Loss, PT.Net_run_rate, PT.Matches_played, PT.Points ,
PT.Team_ID AS PT_Team_ID,T.Team_id AS Team_ID,T.Team_name,T.Team_owner,T.Team_sponsor,T.Captain,T.Head_coach from

Points_table PT full join  Team T
on PT.Team_ID=T.Team_id

--view of point table
create view point_table_view
as
select PT_ID, Win, Loss, Net_run_rate, Matches_played, Points ,Team_ID 
from Points_table 

--pointstable procedure
create procedure sp_pointstable
    @update_insert_read_delete_seeView int,
    @update_insert_read_delete_View int = null,
    @PT_ID int = null,
    @Team_ID int = null,
    @Win varchar(50) = null,
    @Loss varchar(50) = null,
    @Net_run_rate float = null,
    @Matches_played varchar(50) = null,
    @Points int = null
as
begin

Begin Transaction pointstable_trans
begin try

    if (@update_insert_read_delete_seeView = 0) -- insert on 0
    begin
        insert into Points_table (Win, Loss, Net_run_rate, Matches_played, Points, Team_ID)
        values (@Win, @Loss, @Net_run_rate, @Matches_played, @Points, @Team_ID)
        
        if (@update_insert_read_delete_View = 1 And @Team_ID!=null)
        begin
            insert into point_table_view (Win, Loss, Net_run_rate, Matches_played, Points, Team_ID)
            values (@Win, @Loss, @Net_run_rate, @Matches_played, @Points, @Team_ID)
        end
    end
    else if (@update_insert_read_delete_seeView = 1) -- update on 1
    begin
        if (@Team_ID is not null)
        begin
            update Points_table
            set
                Win = isnull(@Win, Win),
                Loss = isnull(@Loss, Loss),
                Net_run_rate = isnull(@Net_run_rate, Net_run_rate),
                Matches_played = isnull(@Matches_played, Matches_played),
                Points = isnull(@Points, Points),
				Team_ID = isnull(@Team_ID ,Team_ID)
				where Team_ID = @Team_ID
		
            if (@update_insert_read_delete_View = 1)
            begin
                update point_table_view
                set
                    Win = isnull(@Win, Win),
                    Loss = isnull(@Loss, Loss),
                    Net_run_rate = isnull(@Net_run_rate, Net_run_rate),
                    Matches_played = isnull(@Matches_played, Matches_played),
                    Points = isnull(@Points, Points),
					Team_ID = isnull(@Team_ID ,Team_ID)
					where Team_ID = @Team_ID
            end
        end
        else
        begin
            update Points_table
            set
                Win = isnull(@Win, Win),
                Loss = isnull(@Loss, Loss),
                Net_run_rate = isnull(@Net_run_rate, Net_run_rate),
                Matches_played = isnull(@Matches_played, Matches_played),
                Points = isnull(@Points, Points),
				Team_ID = isnull(@Team_ID ,Team_ID)
            where PT_ID = @PT_ID

            if (@update_insert_read_delete_View = 1)
            begin
                update point_table_view
                set
                    Win = isnull(@Win, Win),
                    Loss = isnull(@Loss, Loss),
                    Net_run_rate = isnull(@Net_run_rate, Net_run_rate),
                    Matches_played = isnull(@Matches_played, Matches_played),
                    Points = isnull(@Points, Points),
					Team_ID = isnull(@Team_ID ,Team_ID)
                where PT_ID = @PT_ID
            end
        end
    end
    else if (@update_insert_read_delete_seeView = 2) -- read on 2
    begin
        select * from Points_table
    end
    else if (@update_insert_read_delete_seeView = 3) -- read based on team id or pt_id on 3
    begin
        if (@Team_ID is not null)
        begin
            select * from Points_table
            where Team_ID = @Team_ID
        end
        else
        begin
            select * from Points_table
            where PT_ID = @PT_ID
        end
    end
    else if (@update_insert_read_delete_seeView = 4) -- delete based on pt_id or team_id on 4
    begin
        if (@Team_ID is not null)
        begin
            delete from Points_table
            where Team_ID = @Team_ID

            if (@update_insert_read_delete_View = 1) -- delete from view
            begin
                delete from point_table_view
                where Team_ID = @Team_ID
            end
        end
        else
        begin
            delete from Points_table
            where PT_ID = @PT_ID

            if (@update_insert_read_delete_View = 1)-- delete from view
            begin
                delete from point_table_view
                where PT_ID = @PT_ID
            end
        end
    end
    else if (@update_insert_read_delete_seeView = 5)
    begin
        select * from point_table_view
    end

	else if (@update_insert_read_delete_seeView = 6)
	begin
		select * from Team_AND_point_table_view
	end
    else
    begin
        print 'please enter the correct option'
    end

	commit transaction pointstable_trans
	end try
	begin catch
		rollback transaction pointstable_trans
	end catch
end


--Points_table_trigger
create trigger Points_table_trigger
on Points_table
after insert, update, delete
as
begin
    select * from Points_table
end

--Points_table_view_trigger
create trigger Points_table_view_trigger
on point_table_view
instead of insert, update, delete
as begin
	print'Point table vew'
    select * from point_table_view
end
/*
    @update(1)_insert(0)_read(2 ,3=base on team id)_delete(4= base on team id or pT_id -> write null  for del base on pt id)_seeView(5 , 6= point join with team in view) int , 
	@update_insert_read_delete_View int=NULL,
    @PT_ID int = null,
	@Team_ID int = null,
    @Win varchar(50) = null,
    @Loss varchar(50) = null,
    @Net_run_rate float = null,
    @Matches_played varchar(50) = null,
    @Points int = null
*/

exec sp_pointstable 2

exec sp_pointstable 0,1, 27, 12, '4', '6', -0.5, '10', 8;

exec sp_pointstable 1,1, 28, 1, '7', '3', 1.2, '10', 14;

--Team squad table
create table Team_squad
(
	TS_ID int not null primary key identity(1,1),	--PK(Team squad id)
	Batter varchar(100),
	Bowler varchar(100),
	WK varchar(100),	--Wicket keeper
	All_rounder varchar(100),

	--Foreign key
	Team_ID int foreign key references Team(Team_id)	--FK (Team id)
);
--view of team and team squad using joins
create view Team_And_TeamSquad_view as
select TS.TS_ID,TS.All_rounder,TS.Batter,TS.Bowler, TS.Team_ID as TS_Team_ID ,TS.WK,  
T.Captain,T.Head_coach,T.Team_id as Team_ID , T.Team_name,T.Team_owner,T.Team_sponsor from
Team_squad TS full join Team T
on TS.Team_ID=T.Team_id


--view of team squad
create view team_squad_view as
select TS_ID,Batter,Bowler,WK,All_rounder,Team_ID
from Team_squad


--team squad procedure
create procedure sp_teamsquad
    @update_insert_read_delete_seeView int,
    @update_insert_read_delete_view int=NULL,
    @TS_ID int = null,
	@Team_ID int = null,
    @Batter varchar(100) = null,
    @Bowler varchar(100) = null,
    @WK varchar(100) = null,
    @All_rounder varchar(100) = null
   
as
begin
Begin Transaction teamsquad_trans
begin try

    if (@update_insert_read_delete_seeView = 0) -- insert on 0
    begin
        insert into Team_squad (Batter, Bowler, WK, All_rounder, Team_ID)
        values (@Batter, @Bowler, @WK, @All_rounder, @Team_ID)

		if(@update_insert_read_delete_view=1 AND @Team_ID!=NUll)
		begin
		insert into team_squad_view (Batter, Bowler, WK, All_rounder, Team_ID)
        values (@Batter, @Bowler, @WK, @All_rounder, @Team_ID)
		end
    end

    else if (@update_insert_read_delete_seeView = 1) -- update on 1
    begin
        if (@Team_ID is not null)
        begin
            update Team_squad
            set
                Batter = isnull(@Batter, Batter),
                Bowler = isnull(@Bowler, Bowler),
                WK = isnull(@WK, WK),
                All_rounder = isnull(@All_rounder, All_rounder)
            where Team_ID = @Team_ID
			if(@update_insert_read_delete_view=1)
			begin
				update team_squad_view
            set
                Batter = isnull(@Batter, Batter),
                Bowler = isnull(@Bowler, Bowler),
                WK = isnull(@WK, WK),
                All_rounder = isnull(@All_rounder, All_rounder),
				Team_ID=isnull(@Team_ID,Team_ID)
            where Team_ID = @Team_ID
			end
        end

        else
        begin
            update Team_squad
            set
				Team_ID=isnull(@Team_ID,Team_ID),
                Batter = isnull(@Batter, Batter),
                Bowler = isnull(@Bowler, Bowler),
                WK = isnull(@WK, WK),
                All_rounder = isnull(@All_rounder, All_rounder)
            where TS_ID = @TS_ID

			if(@update_insert_read_delete_view=1)
			begin
				update team_squad_view
            set
				Team_ID=isnull(@Team_ID,Team_ID),
                Batter = isnull(@Batter, Batter),
                Bowler = isnull(@Bowler, Bowler),
                WK = isnull(@WK, WK),
                All_rounder = isnull(@All_rounder, All_rounder)
            where TS_ID = @TS_ID
			end
        end
    end

    else if (@update_insert_read_delete_seeView = 2) -- read on 2
    begin
        select * from Team_squad
    end

    else if (@update_insert_read_delete_seeView = 3) -- read based on team id or ts_id on 3
    begin
        if (@Team_ID is not null)
        begin
            select * from Team_squad
            where Team_ID = @Team_ID
        end
        else
        begin
            select * from Team_squad
            where TS_ID = @TS_ID
        end
    end

    else if (@update_insert_read_delete_seeView = 4) -- delete based on ts_id or team_id on 4
    begin
        if (@Team_ID is not null)
        begin
            delete from Team_squad
            where Team_ID = @Team_ID

			if(@update_insert_read_delete_view=1)-- delete from view
			begin
				delete from team_squad_view
            where Team_ID = @Team_ID
			end
        end
        else
        begin
            delete from Team_squad
            where TS_ID = @TS_ID

			if(@update_insert_read_delete_view=1 and @Team_ID=null)
			begin
				delete from team_squad_view
				where TS_ID = @TS_ID
			end

        end
    end

	else if (@update_insert_read_delete_seeView=5)
	begin
		select * from team_squad_view
	end

	else if (@update_insert_read_delete_seeView=6)
	begin
		select * from Team_And_TeamSquad_view
	end

    else
    begin
        print 'please enter the correct option'
    end

	commit transaction teamsquad_trans
	end try
	begin catch
		rollback transaction teamsquad_trans
	end catch
end
--Team_squad_trigger
create trigger Team_squad_trigger
on Team_squad
after insert, update, delete
as
begin
    select * from Team_squad
end
--Team_squad_view_trigger
create trigger Team_squad_view_trigger
on team_squad_view
instead of insert, update, delete
as
begin
	print 'view of team squad'
    select * from team_squad_view
end
/*
	@update(1)_insert(0)_read(2 ,3=base on team id)_delete(4=base on team id or team squad id)_seeView(5) int , 
    @update_insert_read_delete_view int=NULL,
    @TS_ID int = null,
	 @Team_ID int = null
    @Batter varchar(100) = null,
    @Bowler varchar(100) = null,
    @WK varchar(100) = null,
    @All_rounder varchar(100) = null,
   
*/
exec sp_teamsquad 2
exec sp_teamsquad 0,1,'ali','nawaz','asim khan','babar'
exec sp_teamsquad 0,1,NULL,12,'ahmed','shoad','a','z'

    exec sp_teamsquad 1,1, NULl ,12,'Iftikhar Ahmed','Mohammad Hasnain' ,'Sarfaraz Ahmed', 'Ben Cutting';
	exec sp_teamsquad 1,1, Null ,12,'Jason Roy','Naseem Shah' ,'Sarfaraz Ahmed','Muhammad Nawaz';
	
	
	--TS_Id ,team id , batter bowler , wk ,Al_rounder 

EXEC sp_teamsquad 0, 1, NULL, 1, 'Fakhar Zaman'
EXEC sp_teamsquad 0, 1, NULL, 1, 'Abdullah Shafique'

EXEC sp_teamsquad 1, 1, 7, null,null,null ,'Phil Salt'
EXEC sp_teamsquad 1, 1, 7, null,null,null ,'Rashid Khan'

EXEC sp_teamsquad 1, 1, 7, null ,NULl ,'Shaheen Afridi'
EXEC sp_teamsquad 1, 1, 8, null ,Null ,'Haris Rauf'


EXEC sp_teamsquad 1, 1, 7 ,NULL, null,null ,null,'David Wiese'
EXEC sp_teamsquad 1, 1, 8 ,NULL, null,null ,null,'Sikandar Raza'


	



exec sp_teamsquad 2
--Umpire table
create table Umpire
(
	Ump_ID int not null primary key identity(1,1),	--PK(Umpire id)
	[Name] varchar(100),
	Nationality varchar(50),
	No_of_Matches int --No of matches served
);
--umpire view 
create view Umpire_view as
select Ump_ID ,[Name],Nationality,No_of_Matches
from Umpire

--umpire procedure
create procedure sp_umpire
    @update_insert_read_delete_seeView int,
    @update_insert_read_delete_View int =Null,
    @Ump_ID int = null,
    @Name varchar(100) = null,
    @Nationality varchar(50) = null,
    @No_of_Matches int = null
as
begin
Begin Transaction umpire_trans
begin try

    if (@update_insert_read_delete_seeView = 0) -- insert on 0
    begin
        insert into Umpire ([Name], Nationality, No_of_Matches)
        values (@Name, @Nationality, @No_of_Matches)

		if(@update_insert_read_delete_View=1)
		begin
		insert into Umpire_view ([Name], Nationality, No_of_Matches)
        values (@Name, @Nationality, @No_of_Matches)
		end
    end

    else if (@update_insert_read_delete_seeView = 1) -- update on 1
    begin
		update Umpire
		set
		[Name] = isnull(@Name, [Name]),
		Nationality = isnull(@Nationality, Nationality),
		No_of_Matches = isnull(@No_of_Matches, No_of_Matches)
		where Ump_ID = @Ump_ID

		if(@update_insert_read_delete_View=1)
		begin
		update Umpire_view
		set
		[Name] = isnull(@Name, [Name]),
		Nationality = isnull(@Nationality, Nationality),
		No_of_Matches = isnull(@No_of_Matches, No_of_Matches)
		where Ump_ID = @Ump_ID
		end
    end
    

    else if (@update_insert_read_delete_seeView = 2) -- read on 2
    begin
        select * from Umpire
    end

    else if (@update_insert_read_delete_seeView = 3) -- read based on umpire id on 3
    begin
         select * from Umpire
         where Ump_ID = @Ump_ID
    end

    else if (@update_insert_read_delete_seeView = 4) -- delete based on umpire id on 4
    begin
        delete from Umpire
        where Ump_ID = @Ump_ID
		if(@update_insert_read_delete_View=1)
		begin
		delete from Umpire_view
        where Ump_ID = @Ump_ID	
		end
    end
	else if (@update_insert_read_delete_seeView = 5) 
    begin
        select * from Umpire_view
    end
    else
    begin
        print 'please enter the correct option'
    end

	commit transaction umpire_trans
	end try
	begin catch
		rollback transaction umpire_trans
	end catch
end
--Umpire_trigger
create trigger Umpire_trigger
on Umpire
after insert, update, delete
as begin
    select * from Umpire
end
--Umpire_view_trigger
create trigger Umpire_view_trigger
on Umpire_view
instead of insert, update, delete
as begin
    select * from Umpire_view
end
/*
@update_insert_read_delete_seeView int,
    @update_insert_read_delete_View int =Null,
    @Ump_ID int = null,
    @Name varchar(100) = null,
    @Nationality varchar(50) = null,
    @No_of_Matches int = null*/

exec sp_umpire 2

exec sp_umpire 0,1,NUll, 'Aleem Dar', 'Pakistan', 45;
exec sp_umpire 0,1, NULL, 'Richard Illingworth', 'England', 38;
exec sp_umpire 0,1,NULL, 'Ruchira Palliyaguruge', 'Sri Lanka', 29;
exec sp_umpire 0,1,NULL, 'Michael Gough', 'England', 33;
-- Venue table
create table Venue
(
	Venue_ID int not null primary key identity(1,1),
	Venue_name varchar(100),
	Capacity int,
	City varchar(100),
	Country varchar(100)
);

--venue view
create view venue_view as
select Venue_ID,Venue_name,Capacity,City,Country 
from Venue
--venue procedure
create procedure sp_venue
    @update_insert_read_delete_seeView int,
    @update_insert_read_delete_view int =null,
    @Venue_ID int = null,
    @Venue_name varchar(100) = null,
    @Capacity int = null,
    @City varchar(100) = null,
    @Country varchar(100) = null
as
begin
Begin Transaction venue_trans
begin try

    if (@update_insert_read_delete_seeView = 0) -- insert on 0
    begin
        insert into Venue (Venue_name, Capacity, City, Country)
        values (@Venue_name, @Capacity, @City, @Country)
		if (@update_insert_read_delete_view=1)
		begin
		insert into venue_view (Venue_name, Capacity, City, Country)
        values (@Venue_name, @Capacity, @City, @Country)
		end
    end

    else if (@update_insert_read_delete_seeView = 1) -- update on 1
    begin
        update Venue
        set
            Venue_name = isnull(@Venue_name, Venue_name),
            Capacity = isnull(@Capacity, Capacity),
            City = isnull(@City, City),
            Country = isnull(@Country, Country)
        where Venue_ID = @Venue_ID
		if (@update_insert_read_delete_view=1)
		begin
		update venue_view
        set
            Venue_name = isnull(@Venue_name, Venue_name),
            Capacity = isnull(@Capacity, Capacity),
            City = isnull(@City, City),
            Country = isnull(@Country, Country)
        where Venue_ID = @Venue_ID
		end
    end
    
    else if (@update_insert_read_delete_seeView = 2) -- read on 2
    begin
        select * from Venue
    end

    else if (@update_insert_read_delete_seeView = 3) -- read based on venue id on 3
    begin
         select * from Venue
         where Venue_ID = @Venue_ID
    end

    else if (@update_insert_read_delete_seeView = 4) -- delete based on venue id on 4
    begin
        delete from Venue
        where Venue_ID = @Venue_ID
		
		if (@update_insert_read_delete_view=1)
		begin
		delete from venue_view
        where Venue_ID = @Venue_ID
		end

    end

	else if (@update_insert_read_delete_seeView = 5) 
    begin
		select * from venue_view
    end

    else
    begin
        print 'please enter the correct option'
    end

	commit transaction venue_trans
	end try
	begin catch
		rollback transaction venue_trans
	end catch
end
--Venue_trigger
create trigger Venue_trigger
on Venue
after insert, update, delete
as
begin
    select * from Venue
end
--Venue_view_trigger
create trigger Venue_view_trigger
on venue_view
instead of insert, update, delete
as
begin
	print 'View of venue'
    select * from venue_view
end
/*
	@update_insert_read_delete_seeView int,
    @update_insert_read_delete_view int =null,
    @Venue_ID int = null,
    @Venue_name varchar(100) = null,
    @Capacity varchar(50) = null,
    @City varchar(100) = null,
    @Country varchar(100) = null
*/

exec sp_venue 2

exec sp_venue 1,1, 1, 'Gaddafi Stadium', 27000, 'Lahore', 'Pakistan';

exec sp_venue 1,1, 2, 'Karachi Stadium', 35000, 'Karachi', 'Pakistan';

--Matches table
create table Matches
(
	Match_ID int not null primary key identity(1,1),
	MOM varchar(50),	--Man of match
	MType varchar(50),	--Match type
	Result varchar(100),
	[Date] varchar(50),
	[Time] varchar(50),	

	--Foeign keys
	Team1_ID int foreign key references Team(Team_id),	--FK (Team 1 id)
	Team2_ID int foreign key references Team(Team_id),	--FK (Team 2 id)
	Umpire_ID int foreign key references Umpire(Ump_ID),
    Venue_ID int foreign key references Venue(Venue_ID)
);
--view using join on match , venue , umpire and team table
create view match_venue_umpire_team_VIEW as
select  Match_ID,MOM,MType,Result,[Date],[Time],Team1_ID,Team2_ID,M.Umpire_ID as M_Umpire_ID,M.Venue_ID as M_Venue_id  ,
		V.Venue_ID as venue_ID,Venue_name,Capacity,City,Country,
		U.Ump_ID as UmpireID ,[Name],Nationality,No_of_Matches,
		T1.Team_id as Team1ID ,T1.Team_Name as team1_name ,T1.Team_owner as team1_owner,T1.Team_sponsor as team1_sponsor,T1.Captain as team1_caption,T1.Head_coach as team1_coach,
		T2.Team_id as Team2ID ,T2.Team_Name as team2_name ,T2.Team_owner as team2_owner,T2.Team_sponsor as team2_sponsor,T2.Captain as team2_caption,T2.Head_coach as team2_coach

from Matches M
full join Venue V 
on M.Venue_ID=V.Venue_ID

full join Umpire U 
on M.Umpire_ID=U.Ump_ID

full join Team T1 
on M.Team1_ID=T1.Team_id 

right join Team T2 
on M.Team2_ID=T2.Team_id

--view of match
create view matches_view as
select Match_ID,MOM,MType,Result,[Date],[Time],Team1_ID,Team2_ID,Umpire_ID,Venue_ID
from Matches
--match procedure
create procedure sp_matches
    @update_insert_read_delete_seeView int,
    @update_insert_read_delete_View int=NULL,
    @Match_ID int = null,
    @MOM varchar(50) = null,
    @MType varchar(50) = null,
    @Result varchar(100) = null,
    @Date varchar(50) = null,
    @Time varchar(50) = null,
    @Team1_ID int = null,
    @Team2_ID int = null,
    @Umpire_ID int = null,
    @Venue_ID int = null
as
begin
Begin Transaction matches_trans
begin try

    if (@update_insert_read_delete_seeView = 0) -- insert on 0
    begin
        insert into Matches (MOM, MType, Result, [Date], [Time], Team1_ID, Team2_ID, Umpire_ID, Venue_ID)
        values (@MOM, @MType, @Result, @Date, @Time, @Team1_ID, @Team2_ID, @Umpire_ID, @Venue_ID)
		
		if (@update_insert_read_delete_View = 1 and @Match_ID!=Null )
		begin
        insert into Matches (MOM, MType, Result, [Date], [Time], Team1_ID, Team2_ID, Umpire_ID, Venue_ID)
        values (@MOM, @MType, @Result, @Date, @Time, @Team1_ID, @Team2_ID, @Umpire_ID, @Venue_ID)
		end
    end

    else if (@update_insert_read_delete_seeView = 1) -- update on 1
    begin
        if (@Venue_ID is not null)
        begin
            update Matches
            set
                MOM = isnull(@MOM, MOM),
                MType = isnull(@MType, MType),
                Result = isnull(@Result, Result),
                [Date] = isnull(@Date, [Date]),
                [Time] = isnull(@Time, [Time]),
                Team1_ID = isnull(@Team1_ID, Team1_ID),
                Team2_ID = isnull(@Team2_ID, Team2_ID),
                Umpire_ID = isnull(@Umpire_ID, Umpire_ID)
            where Venue_ID = @Venue_ID
			if(@update_insert_read_delete_View=1)
			begin
				update matches_view
            set
                MOM = isnull(@MOM, MOM),
                MType = isnull(@MType, MType),
                Result = isnull(@Result, Result),
                [Date] = isnull(@Date, [Date]),
                [Time] = isnull(@Time, [Time]),
                Team1_ID = isnull(@Team1_ID, Team1_ID),
                Team2_ID = isnull(@Team2_ID, Team2_ID),
                Umpire_ID = isnull(@Umpire_ID, Umpire_ID)
            where Venue_ID = @Venue_ID
			end 
        end
        else
        begin
            update Matches
            set
                MOM = isnull(@MOM, MOM),
                MType = isnull(@MType, MType),
                Result = isnull(@Result, Result),
                [Date] = isnull(@Date, [Date]),
                [Time] = isnull(@Time, [Time]),
                Team1_ID = isnull(@Team1_ID, Team1_ID),
                Team2_ID = isnull(@Team2_ID, Team2_ID),
                Umpire_ID = isnull(@Umpire_ID, Umpire_ID),
				Venue_ID= isnull(@Venue_ID, Venue_ID)
            where Match_ID = @Match_ID
			if(@update_insert_read_delete_View=1)
			begin
				update matches_view
            set
                MOM = isnull(@MOM, MOM),
                MType = isnull(@MType, MType),
                Result = isnull(@Result, Result),
                [Date] = isnull(@Date, [Date]),
                [Time] = isnull(@Time, [Time]),
                Team1_ID = isnull(@Team1_ID, Team1_ID),
                Team2_ID = isnull(@Team2_ID, Team2_ID),
                Umpire_ID = isnull(@Umpire_ID, Umpire_ID),
				Venue_ID= isnull(@Venue_ID, Venue_ID)
            where Match_ID = @Match_ID
			end
        end
    end
    
    else if (@update_insert_read_delete_seeView = 2) -- read on 2
    begin
        select * from Matches
    end

    else if (@update_insert_read_delete_seeView = 3) -- read based on match id or venue id on 3
    begin
		 if (@Venue_ID is not null)
        begin
            select * from Matches
            where Venue_ID = @Venue_ID
        end
        else
        begin
            select * from Matches
            where Match_ID = @Match_ID
        end
        
    end

    else if (@update_insert_read_delete_seeView = 4) -- delete based on match id or venue id on 4
    begin
		if (@Venue_ID is not null)
        begin
            delete from Matches
            where Venue_ID = @Venue_ID

			if(@update_insert_read_delete_View=1)
			begin
				delete from matches_view
				where Venue_ID = @Venue_ID
			end
        end
        else
        begin
            delete from Matches
            where Match_ID = @Match_ID
			if(@update_insert_read_delete_View=1)
			begin
				delete from matches_view
				where Match_ID = @Match_ID
			end
        end
        
    end

	else if (@update_insert_read_delete_seeView = 5) --read view on 5
    begin
		select * from matches_view
    end

	else if (@update_insert_read_delete_seeView = 6) --read view with join on 6
    begin
		select * from match_venue_umpire_team_VIEW
	end

    else
    begin
        print 'please enter the correct option'
    end
	commit transaction matches_trans
	end try
	begin catch
		rollback transaction matches_trans
	end catch
end
--Matches_trigger
create trigger Matches_trigger
on Matches
after insert, update, delete
as
begin
    select * from Matches
end
--Matches_view_trigger
alter trigger Matches_view_trigger
on matches_view
instead of insert, update, delete
as
begin
	print'matches view'
    select * from matches_view
end
/*
  @update_insert_read_delete_seeView int,
    @update_insert_read_delete_View int=NULL,
    @Match_ID int = null,
    @MOM varchar(50) = null,
    @MType varchar(50) = null,
    @Result varchar(100) = null,
    @Date date = null,
    @Time time = null,
    @Team1_ID int = null,
    @Team2_ID int = null,
    @Umpire_ID int = null,
    @Venue_ID int = null
*/

EXEC sp_matches 0,1, NULL, 'ahmed', 't20', 'won by 12(team 2)', '2018-05-25', '10:20:27', 1, 12, 1, 2;
exec sp_matches 2
exec sp_matches 4,1,2

-- Match between Lahore Qalandars and Quetta Gladiators
EXEC sp_matches 1,1,  2, 'Shaheen Afridi', 'T20', 'Lahore Qalandars won by 8 wickets', '2024-06-11', '08:00:00 PM', 1, 12, 1, 2;


create table Matches_Teams 
(
    match_team_id int PRIMARY KEY IDENTITY (1,1),
    team_id int FOREIGN KEY REFERENCES Team(Team_id),
    match_id int FOREIGN KEY  REFERENCES Matches(Match_ID)
);
--matches ,Matches_Teams ,team view
create view Team_Matches_view as
select MT.match_team_id,MT.team_id ,MT.match_id,
	   Team_Name ,Team_owner,Team_sponsor,Captain,Head_coach,
	   MType,Result,[Date],[Time],M.Team1_ID,M.Team2_ID,Umpire_ID,Venue_ID

from Matches_Teams MT
full join Team T 
on MT.team_id=T.Team_id
full join Matches M
on MT.match_id=M.Match_ID

--Matches_Teams view
create view Matches_Teams_view as
select MT.match_team_id,MT.team_id ,MT.match_id
from Matches_Teams MT

--Matches_Teams procedure
create procedure sp_matchesTeams 
    @update_insert_read_delete_seeView int,
    @update_insert_read_delete_View int=NULL,
    @match_team_id int = null,
    @team_id int = null,
    @match_id int = null
as
begin
Begin Transaction matchesTeams_trans
begin try

    if (@update_insert_read_delete_seeView = 0) -- insert
    begin
        insert into Matches_Teams (team_id, match_id)
        values (@team_id, @match_id)
		if (@update_insert_read_delete_View = 0) -- insert in view
		begin
			insert into Matches_Teams_view (team_id, match_id)
			values (@team_id, @match_id)
		end

    end
    else if (@update_insert_read_delete_seeView = 1) -- update
    begin
        print 'Updation not supported for Matches_Teams (its the reltion table)'
    end
    else if (@update_insert_read_delete_seeView = 2) -- read
    begin
        select * from Matches_Teams
    end
    else if (@update_insert_read_delete_seeView = 3) -- read based on match_team_id
    begin
        select * from Matches_Teams 
		where 
		match_team_id = @match_team_id
    end
    else if (@update_insert_read_delete_seeView = 4) -- delete based on match_team_id
    begin
        delete from Matches_Teams 
		where 
		match_team_id = @match_team_id
		if (@update_insert_read_delete_View = 3) 
		begin
			delete from Matches_Teams_view 
			where 
			match_team_id = @match_team_id
		end
    end
	else if (@update_insert_read_delete_seeView = 5) -- see view on 5
    begin
		select * from Matches_Teams_view 
    end
    else
    begin
        print 'please enter the correct option'
    end

	commit transaction matchesTeams_trans
	end try
	begin catch
		rollback transaction matchesTeams_trans
	end catch
end
--Matches_Teams_Trigger
create trigger Matches_Teams_Trigger
on Matches_Teams
after insert, update, delete
as
begin
    select * from Matches_Teams
end
--Matches_Teams_view_Trigger
create trigger Matches_Teams_view_Trigger
on Matches_Teams_view
instead of insert, update, delete
as
begin
    select * from Matches_Teams_view
end
/*
@update_insert_read_delete_seeView int,
    @update_insert_read_delete_View int=NULL,
    @match_team_id int = null,
    @team_id int = null,
    @match_id int = null
*/
exec sp_matchesteams 0,1,Null,1,7
exec sp_matchesteams 0,1,Null,12,7

-- Points_Tables_Teams table
create table Points_Tables_Teams 
(
    PT_Team_ID int PRIMARY KEY IDENTITY (1,1),
    Team_ID int FOREIGN KEY REFERENCES Team(Team_id),
    P_TableID INT FOREIGN KEY REFERENCES Points_table(PT_ID),
);
--Point_Table  ,Team_ view
create view Team_Point_Table_view as
select PTT.P_TableID , PTT.PT_Team_ID , PTT.Team_ID,
	   Team_Name ,Team_owner,Team_sponsor,Captain,Head_coach,
	   Win, Loss, Net_run_rate, Matches_played, Points ,Pt.Team_ID as point_table_team_id
from Points_Tables_Teams PTT
full join Team T 
on PTT.team_id=T.Team_id

full join Points_table Pt
on PTT.P_TableID=Pt.PT_ID

--Point_Table view
create view Points_Tables_Teams_view as
select P_TableID , PT_Team_ID , Team_ID
from Points_Tables_Teams

--Point_Table procedure
create procedure sp_pointstablesteams
    @update_insert_read_delete_seeView int,
    @update_insert_read_delete_view int=null,
    @pt_team_id int = null,
    @team_id int = null,
    @p_tableid int = null
as
begin

Begin Transaction pointstablesteams_trans
begin try

    if (@update_insert_read_delete_seeView = 0) -- insert
    begin
		insert into Points_Tables_Teams (team_id, p_tableid)
        values (@team_id, @p_tableid)
		 if (@update_insert_read_delete_seeView = 0) -- insert in view
		begin
			insert into Points_Tables_Teams_view (team_id, p_tableid)
			values (@team_id, @p_tableid)
		end
    end

    else if (@update_insert_read_delete_seeView = 1) -- update (not implemented for this table)
    begin
		print 'Updation not supported for Points_Tables_Teams (its the reltion table)'
    end

    else if (@update_insert_read_delete_seeView = 2) -- read
    begin
		select * from Points_Tables_Teams
    end

    else if (@update_insert_read_delete_seeView = 3) -- read based on pt_team_id
    begin
		select * from Points_Tables_Teams 
		where pt_team_id = @pt_team_id
    end

    else if (@update_insert_read_delete_seeView = 4) -- delete based on pt_team_id
    begin
        delete from Points_Tables_Teams 
		where pt_team_id = @pt_team_id
		 if (@update_insert_read_delete_seeView = 0)
		begin
			delete from Points_Tables_Teams_view 
			where pt_team_id = @pt_team_id
		end
    end

	else if (@update_insert_read_delete_seeView = 5) -- see view on 5
    begin
		select * from Points_Tables_Teams_view
    end
    else
    begin
        print 'please enter the correct option'
    end

	commit transaction pointstablesteams_trans
	end try
	begin catch
		rollback transaction pointstablesteams_trans
	end catch
end

--Points_Tables_Teams_Trigger
create trigger Points_Tables_Teams_Trigger
on Points_Tables_Teams
after insert, update, delete
as
begin
	select * from Points_Tables_Teams
end

--Points_Tables_Teams_view_trigger
create trigger Points_Tables_Teams_view_trigger
on Points_Tables_Teams_view
instead of insert, update, delete
as
begin
    select * from Points_Tables_Teams_view
end
/*
	@update_insert_read_delete_seeView int,
    @update_insert_read_delete_view int=null,
    @pt_team_id int = null,
    @team_id int = null,
    @p_tableid int = null
*/
exec sp_pointstablesteams 0,1,null,1,28
exec sp_pointstablesteams 0,1,null,12,32



--combined Join
select
	Match_ID,MOM,MType,Result,[Date],[Time],M.Team1_ID,M.Team2_ID,M.Umpire_ID,M.Venue_ID,
	--Umpire
	U.Ump_ID as UmpireID ,[Name],U.Nationality,No_of_Matches,
	--Venue
	V.Venue_ID,V.Venue_name,V.Capacity,V.City,V.Country ,
	--Team 1 & 2
	T1.Team_id as Team1ID ,T1.Team_Name as team1_name ,T1.Team_owner as team1_owner,T1.Team_sponsor as team1_sponsor,T1.Captain as team1_caption,T1.Head_coach as team1_coach,
	T2.Team_id as Team2ID ,T2.Team_Name as team2_name ,T2.Team_owner as team2_owner,T2.Team_sponsor as team2_sponsor,T2.Captain as team2_caption,T2.Head_coach as team2_coach,
	--Point of Team 1 & 2
	PT1.PT_ID, PT1.Win, PT1.Loss, PT1.Net_run_rate, PT1.Matches_played, PT1.Points ,
	PT2.PT_ID, PT2.Win, PT2.Loss, PT2.Net_run_rate, PT2.Matches_played, PT2.Points ,
	--Team squad of  Team 1 & 2
	T1S.TS_ID,T1S.All_rounder,T1S.Batter,T1S.Bowler, T1S.Team_ID as T1S_Team_ID ,T1S.WK,
	T2S.TS_ID,T2S.All_rounder,T2S.Batter,T2S.Bowler, T2S.Team_ID as T2S_Team_ID ,T2S.WK,

	--Players
	P.P_ID as [player id in player table (Pk)] ,PName , DOB , Left_right_hand , P.Nationality , Height 
	
from Matches M
full join Venue V 
on M.Venue_ID=V.Venue_ID

full join Umpire U 
on M.Umpire_ID=U.Ump_ID

full join Team T1 
on M.Team1_ID=T1.Team_id 

full join Team T2 
on M.Team2_ID=T2.Team_id

full  join Points_table PT1
on PT1.Team_ID=T1.Team_id

full join Points_table PT2
on PT2.Team_ID=T2.Team_id

full join Team_squad T1S
on T1S.Team_ID=T1.Team_id

full join Team_squad T2S
on T2S.Team_ID=T2.Team_id

full join Bowling_Stats BowS
on BowS.Player_Team_ID=T1.Team_id

full join Player P
on BowS.P_ID=P.P_ID

-- player bat stats and bowling stats
select 
	P.P_ID as [player id in player table (Pk)] ,PName , DOB , Left_right_hand , Nationality , Height ,
	Bowl_id,BowS.P_ID, BowS.Player_Team_ID,Best_bowl_avg,Best_bowl_SR,Econ,Wickets,Hattric,Five_wickets,Best_figures,
	Bat_ID,BatS.P_ID, BatS.Player_Team_ID,Bat_avg,Bat_SR,Runs,Fours,Sixes,HS,Matches,hundres,fifties
	Team_id ,Team_Name --,Team_owner,Team_sponsor,Captain,Head_coach

from Bowling_Stats BowS

full join Player P
on BowS.P_ID=P.P_ID

full join Batting_Stats BatS
on BatS.P_ID=P.P_ID

full Join Team T
on P.P_ID=T.Team_id





	
	