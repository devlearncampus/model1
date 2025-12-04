package com.ch.model1.singleton;

/*
	전세계 개발자들의 공통적 코드 패턴마다 이름을 붙여서 저서를 한 책의 이름이 Design Pattern 이다
	이 책이 출간 된 이후부터, 개발 시 패턴의 이름을 제시하면 개발자들간 업무 소통이 원활해짐
	
	SingeTon : 하나의 클래스로부터 오직 1개의 인스턴스 생성한 허용하는 클래스 정의 기법 
*/
public class Dog {
	private static Dog instance;
	
	//클래스는 사용하기 위해서 정의햇으므로, 
	//생성자를 private 지정한 후 아무것도 보완하지
	//않으면, 절대로 Dog은 외부에서 사용할수 없다!
	private Dog() {
	}
	
	//외부의 객체가 접근할 수 있는 일반메서드 제공(생성자를 막았으므로)
	//아래의 메서드는 static 수식자(modifer)가 붙지 않았기 때문에
	//인스턴스 소속 메서드가 된다..즉 외부에서 이 메서드를 호출하려면
	//new Dog()으로 강아지의 인스턴스를 생성한 후, 그 인스턴스
	//를 통해 접근할 수 잇따..
	public static Dog getInstance() {
		//인스턴스간 공유되고 있는 클래스 변수에 , 이미 값이 채워져
		//있으면 인스턴스가 존재하는 것이기 때문에 중복해서 new
		//하면 안된다..따라서 최초 한번만 new가 실행되도록 
		//조건문으로 막자..
		if(instance==null) {
			instance = new Dog();
		}
		return instance;
	}
	
	public void bark() {
		System.out.println("멍멍");
	}
}







