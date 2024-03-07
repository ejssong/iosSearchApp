# iosSearchApp
### UserFlow
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/ejssong/iosSearchApp/assets/59044882/c36bac04-461e-4b04-bbe4-e0c0012171f1">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/ejssong/iosSearchApp/assets/59044882/ebed175e-d01e-48d5-850b-e6b82bbd3fa8">
  <img alt="iosSearchAppUserFlow" src="https://github.com/ejssong/iosSearchApp/assets/59044882/c36bac04-461e-4b04-bbe4-e0c0012171f1">
</picture>

### Architecture
- Clean Architecture + MVVM Pattern

```
  |--- Application
  |     |__ DIContainer 
  |     |__ Coordinator : 화면 전환 분담 
  |--- Domain (비지니스 로직을 정의하는 영역) 
  |     |__ Entities : ResponseDTO 
  |     |__ Interfaces : 저장소와 관련
  |     |__ UseCase : 사용자가 해당 서비스를 통해 하고자 하는 것
  |--- Presentation
  |--- Data (데이터 통신 처리) 
  |___ Util (Extension+, UserDefaultsManager 등., )
```

### API Reference

```
  GET https://api.github.com/search/repositories
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `q` | `string` | Keyword  |
| `page` | `string` | Page Number |


### API Edge Case
#### 1.  API 횟수 초과
```bash
  연속으로 API 16 ~ 20 이상 조회시 횟수 초과 에러가 떨어지기 때문에 API 호출을 막아 줘야 한다.
```
#### API Rate Limit Example
```
{
  "message": "API rate limit exceeded for 222.235.198.104. 
  (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)",
  "documentation_url": "https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting"
}
```

#### 2. incomplete : true 로 안 떨어지는 이슈
```bash
  첫번째 페이지에서 total_cnt 와 item 의 개수가 일치 할때 incomplete false로
  떨어지기 때문에 total_cnt & item 개수가 같은 경우 API 호출을 막아줘야 한다.
```
