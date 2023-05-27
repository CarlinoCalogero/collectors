drop function if exists check_data;
delimiter $
create function check_data(data_input date) returns boolean deterministic
begin
	declare errore_data condition for sqlstate "45000";
	if(data_input <= now())
		then
			return true;
	end if;
    signal errore_data set message_text="La data è maggiore di quella odierna";
end$
delimiter ;