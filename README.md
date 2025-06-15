# 🌊 공공 데이터 퀴즈

> 서울시 주요 하천의 수온과 미세먼지 농도를 활용한 환경 퀴즈 앱

**공공 데이터 퀴즈**는 서울시 주요 하천의 수온과 미세먼지 농도 데이터를 활용하여 환경에 대한 관심과 이해를 높일 수 있는 퀴즈 앱입니다.

Flutter + Firebase 기반으로 제작되었으며, 상태관리는 GetX, OTA 업데이트는 Shorebird로 처리됩니다.

---

## 🌐 공식 서비스

- 📱 Google Play: [공공 데이터 퀴즈 앱 설치하기](https://play.google.com/store/apps/details?id=com.jylee.gonggong) - 심사 이의 신청중

---

## 🚀 주요 기능

- 🌡️ **실시간 하천 수온**: 서울시 주요 하천의 실시간 수온 정보 제공
- 💨 **미세먼지 농도**: 하천 주변 지역의 미세먼지 농도 정보 제공
- 🎯 **환경 퀴즈**: 수온과 미세먼지 데이터를 활용한 다양한 환경 퀴즈
- 🎨 **미술관 작품**: 퀴즈 베팅으로 획득한 포인트로 서울시립미술관 작품 감상 및 소장
- 🎲 **작품 가챠**: 획득한 포인트로 서울시립미술관 작품을 랜덤으로 획득
- 📊 **통계**: 개인별 퀴즈 성적 및 환경 지식 향상도 추적

---

## 🛠️ 기술 스택

- **Flutter** (Dart)
- **Firebase**
    - Firestore
    - Authentication
    - 🔧 Cloud Functions
- [GetX](https://pub.dev/packages/get) – 상태관리 및 라우팅
- [Shorebird](https://pub.dev/packages/shorebird_code_push) – 코드 푸시 배포
- [Dio](https://pub.dev/packages/dio) – HTTP 클라이언트
- [Shared Preferences](https://pub.dev/packages/shared_preferences) – 로컬 데이터 저장