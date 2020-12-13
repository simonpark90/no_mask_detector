 

# 📁 No_Mask_Detector(N.M.D)
## 🐸 마스크 착용 감지 프로젝트 🐸
플레이데이터 Pose-Estimation 개발자 교육 과정 최종 프로젝트 - 'N.M.D'
<br><br>
마스크 착용 여부를 딥러닝 모델로 확인하여 Face Identification API를 통해 착용하지 않은 사람을 찾아 별점을 주는 시스템 구축
<br>

## 👩‍💻 팀원 소개
#### • 🧑🏻‍박성우(팀장 및 ML & Frontend) : 딥러닝 모델 개발, 앱 개발, 프로젝트 관리
#### • 👩🏻‍🦰 박채연(Frontend) : Admin 페이지 개발, 웹과 서버 통신(Nodejs), Backend 개발(Node.js express, sequelize)
#### • 🧑🏻‍이병헌(Frontend) : Admin 페이지 개발, 웹과 서버 통신(Nodejs), Backend 개발(Node.js express, sequelize), Face Identification 개발
#### • 👩🏻 박주현(Backend) : AWS 서버 구축, DB 구축
#### • 👩🏻 남기은(Backend) : Face Identification 개발
<br>

## 📚 프로젝트 설명
### <strong>목적<br> </strong>
COVID-19 의 확산으로 인해 마스크 착용이 의무화됨에 따라서 실내 출입 시 마스크 착용 여부 판단을 위한 사회적 비용이 높아지고 있다.   
이러한 사회적 비용을 줄이기 위해 딥러닝 기반 마스크 착용 유무 판단 및 벌점 제도를 통해 특정 집단의 마스크 착용을 장려 또는 강제하는 것을 돕는다.
<br><br>

## 요구 사항
 - 핵심 기능
   - iOS상에서 작동하는 App
   - 마스크 착용 여부 식별
   - 마스크 착용 시 올바른 마스크 착용법을 준수하였는지 식별
   - 마스크 미착용 시 해당 인원 얼굴 식별하여 집단 내 특정 패널티 적용
   
 - 부가 기능
   - 관리자 페이지로 관리 인원 추가 및 삭제
   - 유저 페이지로 본인의 패널티 현황 확인
 
 - 확장 기능
   - 다수의 인원 얼굴 동시 식별
   - 
   
 ### iOS 어플리케이션 API 문서
 ![Screen Shot 2020-12-04 at 1 11 58 PM](https://user-images.githubusercontent.com/64248514/101120975-4f33ed80-3632-11eb-9669-3ffe935b02d5.png)
 ![Screen Shot 2020-12-05 at 11 16 33 PM](https://user-images.githubusercontent.com/64248514/101245772-8d283300-3752-11eb-9743-82b0e51f6d66.png)

## 개발내용
  - Deep learning model 선정 및 마스크 착용 및 미착용 데이터 학습
    - 데이터 전처리
    - 모델 학습
    - iOS에 맞게 모델 변환
    
  - iOS 서비스 앱 개발
    - 앱 개발
    - 앱과 DB 연결
    - Input data 모델의 input 형태로 변환 모듈
    
  - DB 및 서버 개발
    - 사용 DB 선정 및 환경설정
    - DB Architecture 개발

## 📝 사용언어, 기술스택
![Generic badge](https://img.shields.io/badge/platform-Web/iOS-brightgreen.svg) 
![Generic badge](https://img.shields.io/badge/framework-tensorflow/React-green.svg)
![Generic badge](https://img.shields.io/badge/engine-node.js-green.svg)
![Generic badge](https://img.shields.io/badge/database-MySQL-yellow.svg) 
![Generic badge](https://img.shields.io/badge/api-FaceAPI/MobileNetV2-red,.svg) 
![Generic badge](https://img.shields.io/badge/language-Python,JavaScript-important.svg) 
![Generic badge](https://img.shields.io/badge/server-AWS-important.svg)
<br>

## 💻 프로토타입
### 모바일 
![prototype 001](https://user-images.githubusercontent.com/64248514/99365157-40430080-28fa-11eb-8f9f-e5dddd378f9e.jpeg)
### Admin 웹페이지
![prototype 002](https://user-images.githubusercontent.com/64248514/99365170-43d68780-28fa-11eb-8152-1e61b1e8e90d.jpeg)


## 🦴 전체개요
![전체개요](https://user-images.githubusercontent.com/61309080/100186214-f032f200-2f28-11eb-9bc0-691c4d21718e.jpeg)

### 수정후 (2020/12/4)
![Screen Shot 2020-12-04 at 1 12 50 AM](https://user-images.githubusercontent.com/64248514/101056070-ee72c980-35cd-11eb-910f-79140d895ed4.png)
![Screen Shot 2020-12-04 at 1 11 56 AM](https://user-images.githubusercontent.com/64248514/101055912-c1beb200-35cd-11eb-93db-5621b8415aa6.png)

### 수정전
![Screen Shot01](https://user-images.githubusercontent.com/66557175/100188389-6cc7cf80-2f2d-11eb-90d3-321ee46d8adf.PNG)
![Screen Shot02](https://user-images.githubusercontent.com/66557175/100188776-46566400-2f2e-11eb-9d18-a8b7d6a4bbb2.PNG)
- 원본 편집 주소   
https://o365uos-my.sharepoint.com/:x:/g/personal/2016440050_office_uos_ac_kr/EZ1ecBsRLGBHlej1hgj58UAB_hGtvV6s7FHVLKtI6wEwyQ?e=wN0XZh 

<hr> 

### 세부 기술
| 기술 | 버전 | 설명 |
| :--------: | :----: | ---- |
| REST API | ![Generic badge](https://img.shields.io/badge/release--blue.svg) | REST 아키텍처의 제약 조건을 준수하는 애플리케이션 프로그래밍 인터페이스 |
| MVC Pattern | ![Generic badge](https://img.shields.io/badge/release--blue.svg) | 애플리케이션을 Model, View, Controller 세가지의 역할로 구분한 디자인 패턴 |
| ESLint | ![Generic badge](https://img.shields.io/badge/release-6.14.8-blue.svg) | ECMAScript 코드에서 문제점 검사 또는 더 나은 코드로 정정하는 린트 도구 |
| Node.js Express | ![Generic badge](https://img.shields.io/badge/release-6.14.8-blue.svg) | ECMAScript 코드에서 문제점 검사 또는 더 나은 코드로 정정하는 린트 도구 |
| React-Admin | ![Generic badge](https://img.shields.io/badge/release-6.14.8-blue.svg) | ECMAScript 코드에서 문제점 검사 또는 더 나은 코드로 정정하는 린트 도구 |
| Keras | ![Generic badge](https://img.shields.io/badge/release-6.14.8-blue.svg) | ECMAScript 코드에서 문제점 검사 또는 더 나은 코드로 정정하는 린트 도구 |
| MySQL | ![Generic badge](https://img.shields.io/badge/release-6.14.8-blue.svg) | ECMAScript 코드에서 문제점 검사 또는 더 나은 코드로 정정하는 린트 도구 |
| CoreML | ![Generic badge](https://img.shields.io/badge/release-6.14.8-blue.svg) | ECMAScript 코드에서 문제점 검사 또는 더 나은 코드로 정정하는 린트 도구 |
| X-Code | ![Generic badge](https://img.shields.io/badge/release-6.14.8-blue.svg) | ECMAScript 코드에서 문제점 검사 또는 더 나은 코드로 정정하는 린트 도구 |

<br>

## 📜 ERD (Entity Relationship Diagram)
![Screen Shot 2020-12-08 at 9 22 49 AM](https://user-images.githubusercontent.com/64248514/101421241-3af43700-3937-11eb-918d-6f06f501af8f.png)
<br>

| Entity | Attributes | Domains | DataType |
| :------: | ---------- | ------- | ------ |
| MEMBER <br> 회원 | MEM_NO <br> MEM_NAME <br> MEM_COUNT <br> MEM_FACE | 고유 번호(PK) <br> 이름 <br> 벌점 <br> 사진 링크 | INT <br> VARCHAR(45) <br> INT <br> VARCHAR(100) |
| STATE <br> 기록 | ST_NO <br> ST_MEM_NO <br> ST_TIME <br> ST_NOTE | 고유 번호(PK) <br> 회원 번호(FK) <br> 인식 시간 <br> 비고 | INT <br> INT <br> DATETIME <br> VARCHAR(100) | 
| ADMIN <br> 관리자 | ADMIN_NO <br> ADMIN_ID <br> ADMIN_PW <br> ADMIN_TEL | 고유 번호(PK) <br> 아이디 <br> 비밀번호 <br> 전화번호 | INT <br> VARCHAR(45) <br> VARCHAR(45) <br> VARCHAR(45) |

<br><br>

## 🔎 프로젝트 구조

| FrontEnd | BackEnd (main)| BackEnd (test) |
| -------- | ------------- | -------------- |
| ![Screen Shot 2020-10-11 at 9 49 34 PM](https://user-images.githubusercontent.com/64248514/95679127-b2de0380-0c0b-11eb-8a49-c50b1fd676d6.png) | ![Screen Shot 2020-10-11 at 9 44 55 PM](https://user-images.githubusercontent.com/64248514/95679002-1287df00-0c0b-11eb-8141-1c0bd3e5e787.png) | ![Screen Shot 2020-10-11 at 9 25 22 PM](https://user-images.githubusercontent.com/64248514/95678607-b1f7a280-0c08-11eb-8d2c-2856b91e2210.png) |

<br>

# 구현된 기능
  - 
  
# BackEnd API url document
  - Common Field
      - Get an image : /member/faceImages/:imageName, GET
          - return : single image data
      - Log-in : /login, POST
          - return : single admin object
          
  - Member Entity
      - Read all : /member, GET
          - return : all of member objects
      - Create one member : /member, POST
          - return : single member object
          - input image multer key : "memberFace"
      - Update one member : /member/:memberId, PUT
          - return : single member object
          - input image multer key : "updateMemberFace"
      - Delete one member : /member/:memberId, DELETE
          - return : boolean
      - Get one member : /member/:memberId, GET
          - return : single member object
          
   - State Entity
      - Read all : /state, GET
          - return : all of state objects
      - Create one state : /state, POST
          - return : single state object
      - Update one state : /state/:stateId, PUT
          - return : single state object
      - Delete one state : /state/:stateId, DELETE
          - return : boolean
      - Get one state : /state/:stateId, GET
          - return : single state object
          
   - Admin Entity
      - Read all : /admin, GET
          - return : all of admin objects
      - Create one admin : /admin, POST
          - return : single admin object
      - Update one admin : /admin/:adminId, PUT
          - return : single admin object
      - Delete one admin : /admin/:adminId, DELETE
          - return : boolean
      - Get one admin : /admin/:adminId, GET
          - return : single admin object
          
   - iOS
      - Image recognition & penalty : /nomask, POST
          - return : {"result" : "true", "username" : member's name, "count" : penalty count , "eDistance" : euclidean distance from reference picture descriptor } 
                      || { "result": "false", "username" : "unknown", "eDistance" : euclidean distance over 0.6 }
          - input image multer key : "tempFace"
      - Warning admin : /call, GET
          - return :  true || false
 
# 기능별 Git Repository
  - React-admin&React : https://github.com/byungs2/DeepLearningProjectFrontEnd
  - Node.js Express&Sequelize : https://github.com/byungs2/DeepLearningProjectBackEnd
  - Deep learning model and training : https://github.com/simonpark90/mask_deeplearning
  - face-api.js : https://github.com/pure-teatree/FaceApi_Test
  - Swift x React x Node.js express x MySQL : https://github.com/j00hyun/iOS-React-App
