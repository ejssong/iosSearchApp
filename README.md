# iosSearchApp

### Architecture
- Clean Architecture + MVVM Pattern

### API Reference

```http
  GET https://api.github.com/search/repositories
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `q` | `string` | Keyword  |
| `page` | `string` | Page Number |


### API Edge Case
#### 1.  API 횟수 초과
```bash
  연속으로 API 16 ~ 20 이상 태우면 더 이상 호출이 안되기 때문에 API 호출을 막아 줘야 한다.
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

