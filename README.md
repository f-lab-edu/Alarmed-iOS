# Alarmed! - 미션 기반 스마트 알람

**Alarmed!**는 미션 수행을 통해 알람을 해제하는 스마트 알람 서비스입니다.
사용자는 다양한 미션(운동, QR 코드 스캔 등)을 수행해야만 알람을 해제할 수 있으므로 보다 확실한 목표 달성이 가능합니다.

## 주요 기능

### MVP
- **🔔 알람**: 특정 시간 또는 조건에서 알람 트리거
- **🎯 미션 기반 해제**: QR 코드 스캔, 운동 수행과 같은 간단한 미션 제공

### Post MVP
- **🔖 더 많은 미션**: AI 기반 개인화된 알람 및 미션 추천
- **📅 다양한 사용 사례**: 위치 기반 알림 등 목표에 따라 적절한 알림 방식 제공
- **📊 사용자 맞춤 추천**: AI 기반 개인화된 알람 및 미션 추천
- **⚡ 차별화된 UX 제공**: iOS 네이티브 기술을 활용하여 안정적이고 차별화된 사용자 경험 제공 

## 기술 스택

### Apple Frameworks
- **Swift, SwiftUI**
- **Combine** - 비동기 데이터 스트림 처리
- **UserNotifications** - 알람 푸시 처리
- **CloudKit / CoreData** - 로컬 및 클라우드 데이터 저장

### Third-party Libraries
- **The Composable Architecture (TCA)** - 단방향 데이터 흐름과 상태 관리를 지원하는 기능 조합형 아키텍처 프레임워크. 의존성 주입 및 테스트 환경 제공.

## 설치 및 실행 방법
```bash
git clone https://github.com/f-lab-edu/Alarmed-iOS.git
cd App
open Alarmed.xcworkspace
```
