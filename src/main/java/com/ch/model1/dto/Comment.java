package com.ch.model1.dto;

import lombok.Data;

@Data
public class Comment {
	private int comment_id;
	private String msg;
	private String reader;
	private String writedate;
	private int read_count;
	private News news;
}
