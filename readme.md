# PS2판 파이널판타지10 인터내셔널 번역

PS2판 파이널판타지10 인터내셔널의 한글 번역 프로젝트입니다.

## 패치 정보

* 게임 ID: SLPM-67513
* 사용 폰트: 돋움체 또는 [갈무리14](https://github.com/quiple/galmuri)
* 번역 방식: 일본어 번역

## 사용 도구 정보

* [armips](https://github.com/Kingcom/armips): 어셈블리 코드 패치
* [xdelta3](https://github.com/jmacd/xdelta): 패치 파일 생성
* 대부분의 텍스트, 그래픽 도구: 체코어 번역 프로젝트(<https://www.rk-translations.cz>, <https://www.romhacking.net/utilities/1390>)

## 테스트 및 패치 파일 생성 방법

(1) 게임의 ISO 파일을 프로젝트 최상단에 `base.iso`로 복사  
(2) 원하는 폰트에 따라 `build.dotum.bat` 또는 `build.galmuri.bat` 실행  
(3) `ffx_kr_{font}.iso`와 `ffx_kr_{font}.xdelta`가 생성됩니다.
