package com.ssafy;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@ComponentScan(basePackages = {"com.ssafy"})
@SpringBootApplication
public class WhereIsMyHomeSpringApplication {

	public static void main(String[] args) {
		SpringApplication.run(WhereIsMyHomeSpringApplication.class, args);
	}

}
