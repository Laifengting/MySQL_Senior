package com.lft.sharding.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName (value = "t_user") // 实体类名跟表名不一致，会报错。
public class User {
	// 【一定要加这个注解】。标明这个属性是自增属性。否则会报错。无法使用算法。
	@TableId (type = IdType.AUTO)
	private long userId;
	private String username;
	private String ustatus;
}
