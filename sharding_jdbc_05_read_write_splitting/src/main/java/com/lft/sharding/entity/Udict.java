package com.lft.sharding.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName ("t_udict")
public class Udict {
	// 【一定要加这个注解】。标明这个属性是自增属性。否则会报错。无法使用算法。
	@TableId (type = IdType.AUTO)
	private Long dictId;
	private String ustatus;
	private String uvalue;
}
