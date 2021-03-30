package com.lft.sharding.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName (value = "t_user") // 实体类名跟表名不一致，会报错。
public class User {
	@TableId (type = IdType.AUTO)
	private long userId;
	private String username;
	private String ustatus;
}
