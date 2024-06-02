package com.ssafy.config;

import java.util.Arrays;
import java.util.List;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.http.HttpMethod;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.PathResourceResolver;


//import lombok.extern.slf4j.Slf4j;

//@Slf4j
@Configuration
@EnableAspectJAutoProxy
@MapperScan(basePackages = { "com.ssafy.**.mapper" })
public class WebMvcConfiguration implements WebMvcConfigurer {
	
	private final List<String> patterns = Arrays.asList("/board/*", "/user/list");


	@Override
	public void addCorsMappings(CorsRegistry registry) {
		//전부 허용
		registry.addMapping("/**").allowedOrigins("*")
//			제약조건 걸기
//			.allowedOrigins("http://localhost:8080", "http://localhost:8081")
		//전부 허용
				.allowedMethods(HttpMethod.GET.name(), HttpMethod.POST.name(), HttpMethod.PUT.name(),
						HttpMethod.DELETE.name(), HttpMethod.HEAD.name(), HttpMethod.OPTIONS.name(),
						HttpMethod.PATCH.name())
				.maxAge(1800); // 1800초 동안 preflight 결과를 캐시에 저장
	}

	
	// 첫페이지 설정 - 별도로 controller 안 만들어도 된다.
	@Override
	public void addViewControllers(ViewControllerRegistry registry) {
		registry.addViewController("/").setViewName("index");
	}
	
}
