package com.lft.sharding.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lft.sharding.entity.User;
import org.springframework.stereotype.Repository;

@Repository
public interface UserMapper extends BaseMapper<User> {
}