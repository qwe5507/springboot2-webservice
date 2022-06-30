package com.jhlee.book.webservice.web.domain.posts;

import org.springframework.data.jpa.repository.JpaRepository;


public interface PostsRepository extends JpaRepository<Posts, Long> {
}
