package com.lft.sharding;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.lft.sharding.entity.Course;
import com.lft.sharding.entity.Udict;
import com.lft.sharding.entity.User;
import com.lft.sharding.mapper.CourseMapper;
import com.lft.sharding.mapper.UdictMapper;
import com.lft.sharding.mapper.UserMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith (SpringRunner.class)
@SpringBootTest
public class ShardingApplicationTests {
	
	// 注入 mapper
	@Autowired
	private CourseMapper courseMapper;
	
	//======================== 测试水平分表 ========================
	
	/**
	 * 添加课程
	 */
	@Test
	public void addCourse() {
		for (int i = 1; i <= 50; i++) {
			Course course = new Course();
			course.setCname("SQL_" + i);
			course.setUserId(100L + i);
			course.setCstatus("Status_" + i);
			courseMapper.insert(course);
		}
	}
	
	/**
	 * 查询课程
	 */
	@Test
	public void findCourse() {
		QueryWrapper<Course> wrapper1 = new QueryWrapper<>();
		wrapper1.eq("id", 583701067116576769L);
		Course course = courseMapper.selectOne(wrapper1);
		System.out.println(course);
		
		QueryWrapper<Course> wrapper2 = new QueryWrapper<>();
		wrapper2.eq("id", 583701067175297024L);
		course = courseMapper.selectOne(wrapper2);
		System.out.println(course);
	}
	
	//======================== 测试水平分库 ========================
	@Test
	public void addCourseDb() {
		for (int i = 1; i <= 50; i++) {
			Course course = new Course();
			course.setCname("SQL" + i);
			course.setUserId(100L + i);
			course.setCstatus("Status" + i);
			courseMapper.insert(course);
		}
	}
	
	@Test
	public void findCourseDb() {
		QueryWrapper<Course> wrapper = new QueryWrapper<>();
		// 设置查询条件user_id
		wrapper.eq("user_id", 107);
		// 设置查询条件id
		wrapper.eq("id", 583747425215184897L);
		Course course = courseMapper.selectOne(wrapper);
		System.out.println("========================= " + course + " =========================");
	}
	
	//======================== 测试垂直分库 ========================
	@Autowired
	private UserMapper userMapper;
	
	@Test
	public void addUserDb() {
		for (int i = 1; i <= 50; i++) {
			User user = new User();
			user.setUsername("JAVA" + i);
			user.setUstatus("SQL" + i);
			userMapper.insert(user);
		}
	}
	
	@Test
	public void findUserDb() {
		QueryWrapper<User> wrapper = new QueryWrapper<>();
		// 设置查询条件user_id
		wrapper.eq("user_id", 583795835007926272L);
		User user = userMapper.selectOne(wrapper);
		System.out.println("========================= " + user + " =========================");
	}
	
	//======================== 测试公共表 ========================
	@Autowired
	private UdictMapper udictMapper;
	
	@Test
	public void addUdictDb() {
		for (int i = 1; i <= 50; i++) {
			Udict udict = new Udict();
			udict.setUstatus("HAHA" + i);
			udict.setUvalue("Python" + i);
			udictMapper.insert(udict);
		}
	}
	
	@Test
	public void findUdictDb() {
		QueryWrapper<Udict> wrapper = new QueryWrapper<>();
		// 设置查询条件user_id
		wrapper.eq("dict_id", 583803437557219329L);
		Udict udict = udictMapper.selectOne(wrapper);
		System.out.println("========================= " + udict + " =========================");
	}
	
	@Test
	public void deleteDictDb() {
		QueryWrapper<Udict> wrapper = new QueryWrapper<>();
		// 设置查询条件user_id
		wrapper.eq("dict_id", 583803437544636416L);
		udictMapper.delete(wrapper);
	}
	
	//======================== 测试读写分离 ========================
	@Test
	public void addWriteUserDb() {
		for (int i = 1; i <= 50; i++) {
			User user = new User();
			user.setUsername("JAVA" + i);
			user.setUstatus("SQL" + i);
			userMapper.insert(user);
		}
	}
	
	@Test
	public void findReadUserDb() {
		QueryWrapper<User> wrapper = new QueryWrapper<>();
		// 设置查询条件user_id
		wrapper.eq("user_id", 584067306133389312L);
		User user = userMapper.selectOne(wrapper);
		System.out.println("========================= " + user + " =========================");
	}
}
