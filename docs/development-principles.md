# 개발 원칙 (Development Principles)

## 1. TDD (Test-Driven Development)
각 단계별로 테스트를 먼저 작성한 후 구현을 진행합니다.

### 개발 프로세스
1. **Red**: 실패하는 테스트 작성
2. **Green**: 테스트를 통과하는 최소한의 코드 작성
3. **Refactor**: 코드 품질 개선

### 테스트 종류
- **Unit Test**: 개별 함수/클래스 테스트
- **Widget Test**: UI 컴포넌트 테스트
- **Integration Test**: 전체 기능 흐름 테스트

## 2. SOLID 원칙
객체지향 설계의 5가지 원칙을 준수합니다.

### S - Single Responsibility Principle (단일 책임 원칙)
- 클래스는 하나의 책임만 가져야 함
- 변경의 이유가 오직 하나여야 함

### O - Open/Closed Principle (개방/폐쇄 원칙)
- 확장에는 열려있고 수정에는 닫혀있어야 함
- 인터페이스와 추상화 활용

### L - Liskov Substitution Principle (리스코프 치환 원칙)
- 하위 타입은 상위 타입을 대체할 수 있어야 함

### I - Interface Segregation Principle (인터페이스 분리 원칙)
- 클라이언트가 사용하지 않는 메서드에 의존하면 안됨

### D - Dependency Inversion Principle (의존성 역전 원칙)
- 고수준 모듈이 저수준 모듈에 의존하면 안됨
- 추상화에 의존해야 함

## 3. Clean Architecture
계층 간 의존성 방향을 준수합니다.

### 계층 구조
```
presentation/ (UI, State Management)
    ↓
domain/ (Business Logic, Entities, Use Cases)
    ↓
data/ (Data Sources, Repositories Implementation)
```

### 의존성 규칙
- 안쪽 계층은 바깥쪽 계층을 모름
- 도메인 계층이 가장 안정적
- 의존성 주입을 통한 역전

## 4. 커밋 메시지 규칙
명확하고 일관된 커밋 메시지를 작성합니다.

### 형식
```
<type>(<scope>): <subject>

<body>

<footer>
```

### 타입
- **feat**: 새로운 기능
- **fix**: 버그 수정
- **docs**: 문서 변경
- **style**: 코드 스타일 변경
- **refactor**: 리팩토링
- **test**: 테스트 추가/수정
- **chore**: 빌드 프로세스, 도구 변경

### 예시
```
feat(breathing): add breathing exercise timer

- Implement 4-7-8 breathing technique
- Add visual guide with animation
- Include pause/resume functionality

Closes #123
```

## 5. 코드 품질 관리

### Dart Analysis
- `analysis_options.yaml` 설정 준수
- 린트 규칙 엄격 적용
- 코드 품질 지표 모니터링

### 코드 포맷팅
- `dart format` 자동 실행
- 일관된 코드 스타일 유지
- IDE 설정 통일

### 문서화
- 주요 컴포넌트 개발 후 `/docs` 폴더 업데이트
- API 문서 작성
- 아키텍처 결정 기록(ADR) 유지

## 적용 방법

### 1. 기능 개발 전
- [ ] 요구사항 분석
- [ ] 테스트 시나리오 작성
- [ ] 아키텍처 설계

### 2. 개발 중
- [ ] 테스트 먼저 작성
- [ ] 최소 구현으로 테스트 통과
- [ ] 리팩토링으로 품질 개선

### 3. 개발 후
- [ ] 코드 리뷰
- [ ] 문서 업데이트
- [ ] 통합 테스트 실행

## 체크리스트

### 코드 작성 시
- [ ] 단일 책임 원칙 준수
- [ ] 의존성 주입 사용
- [ ] 테스트 가능한 구조
- [ ] 명확한 네이밍

### 커밋 시
- [ ] 테스트 통과 확인
- [ ] 린트 오류 없음
- [ ] 명확한 커밋 메시지
- [ ] 관련 문서 업데이트 