package com.jhlee.book.webservice.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

// applcation.java에서 @EnableJpaAuditing분리를 위함
@Configuration
@EnableJpaAuditing
public class JpaConfig {
}
