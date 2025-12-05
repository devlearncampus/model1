<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
body {font-family: Arial, Helvetica, sans-serif;}
* {box-sizing: border-box;}

input[type=text], select, textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  margin-top: 6px;
  margin-bottom: 16px;
  resize: vertical;
}

input[type=button] {
  background-color: #04AA6D;
  color: white;
  padding: 12px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

input[type=button]:hover {
  background-color: #45a049;
}

.container {
  border-radius: 5px;
  background-color: #f2f2f2;
  padding: 20px;
}
</style>
<!-- include libraries(jQuery, bootstrap) -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<!-- include summernote css/js -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote.min.js"></script>
<script>
	function regist(){
		//적용이 속성이 다수일 경우, 한꺼번에 객체로 지정할 수 있는 .attr() 지원 
		$("form").attr({
			action:"/news/regist", //이 요청을 받는 javaee 기반 기술은 jsp와 servlet 둘가 가능하지만, 디자인이 포함되지 않을 경우엔
											//굳이 jsp 를 사용할 필요가 없다..어차피 jsp로 작성한다고 하여도, 서블릿으로 변환되어짐..
			method:"post"
		});
		$("form").submit(); //이 시점에 전송 요청이 발생!!
	}
	
	$(function(){	
		//서머노트 연동
		$("#summernote").summernote({
			placeholder:"내용을 입력하세요",
			height:250
		});

		//글쓰기와 목록 버튼에 이벤트 연결 
		$("#bt_regist").click(function(){
			//글쓰기 폼 전송 
			regist();
		});
		
	});

</script>
</head>
<body>

<h3>Contact Form</h3>

<div class="container">
  <form>
    <label for="fname">제목</label>
    <input type="text" id="fname" name="title" placeholder="Your title..">

    <label for="lname">작성자</label>
    <input type="text" id="lname" name="writer" placeholder="Your name..">

    <label for="subject">내용</label>
    <textarea id="summernote" name="content" placeholder="Write something.." style="height:200px"></textarea>

    <input type="button" value="글등록" id="bt_regist">
    <input type="button" value="목록" id="bt_list">
  </form>
</div>

</body>
</html>
