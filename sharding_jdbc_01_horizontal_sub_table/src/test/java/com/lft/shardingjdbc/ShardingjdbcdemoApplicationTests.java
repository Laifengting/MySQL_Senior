package com.lft.shardingjdbc;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.lft.shardingjdbc.entity.Course;
import com.lft.shardingjdbc.mapper.CourseMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith (SpringRunner.class)
@SpringBootTest
public class ShardingjdbcdemoApplicationTests {
	// 注入 mapper
	@Autowired
	private CourseMapper courseMapper;
	
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
	
}