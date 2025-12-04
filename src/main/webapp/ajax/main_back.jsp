<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    .container{
        width: 650px;
        height: 500px;
        background-color: azure;
        margin: auto;
    }
    .aside{
        width: 150px;
        height: 100%;
        background-color: beige;
        float:left;
    }
    .aside input{
        width: 90%;
    }
    .aside button{
        width: 40%;
    }

    .content{
        width: 500px;
        height: 100%;
        background-color: aqua;
        float:left;
    }

</style>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script>
    /*  ë¬¸ìê° ë¡ëê° ëë©´, ëê°ì ë²í¼ì ëí´ ì´ë²¤í¸ì°ê²°
        íì´í í¨ì- ê¸°ì¡´ í¨ìì ì ê¸°ë²ì ì¤ì¬ì íí..
    */
    $(()=>{
        //ëê¸° ë²í¼ì í´ë¦­ ì´ë²¤í¸ ì°ê²° 
        $($("form button")[0]).click(()=>{
            //alert("ëê¸° ë°©ìì ìì²­ìë");            
            $("form").attr({
                action:"/ajax/regist.jsp",
                method:"post"
            });
            $("form").submit();
        });

        //ë¹ëê¸° ë²í¼ì í´ë¦­ ì´ë²¤í¸ ì°ê²° 
        $($("form button")[1]).click(()=>{
            alert("ë¹ëê¸° ë°©ìì ìì²­ ìë");            
        });

    });

</script>
</head>
<body>
    <div class="container">
        <div class="aside">
            <form>
                <input type="text" placeholder="Your ID..."        name="id">
                <input type="text" placeholder="Your name..."   name="name">
                <input type="text" placeholder="Your email"     name="email">
                <button>sync</button>
                <button>async</button>
            </form>
        </div>
        <div class="content"></div>
   </div>

</body>
</html>