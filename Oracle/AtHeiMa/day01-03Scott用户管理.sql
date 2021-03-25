----scott用户,密码默认为tiger.实际为201314
--解锁scott用户
alter user scott account unlock;

--解锁scott用户的密码【此句也可以用来重置密码】
alter user scott identified by 201314;

--切换到scott用户下。




















