# Matching Logic

## Current Implementation

### Basic Matching

The current implementation uses a simple mutual-like system:

1. User A likes User B → Entry created in `likes` table
2. User B likes User A → Entry created in `likes` table
3. Database trigger detects mutual like → Match created automatically

### Discovery Filtering

Profiles shown in discovery are filtered by:

1. **Not current user**: `id != auth.uid()`
2. **Not already liked**: User not in `likes` where `from_user = auth.uid()`
3. **Gender preference**: 
   - If user's `looking_for` = 'everyone' → show all
   - Otherwise, show profiles where `gender = user.looking_for`
4. **Ordering**: By `created_at` DESC (newest first)

### SQL Query (from migration)

```sql
select p.*
from public.profiles p
where p.id != auth.uid()
  and (
    p.gender = (select looking_for from public.profiles where id = auth.uid())
    or (select looking_for from public.profiles where id = auth.uid()) = 'everyone'
  )
  and p.id not in (
    select to_user from public.likes where from_user = auth.uid()
  )
order by p.created_at desc
limit 20
```

## Future Enhancements

### Location-Based Matching

Add distance-based filtering:

```sql
-- Filter by distance (e.g., within 50km)
WHERE ST_DWithin(
  ST_MakePoint(p.longitude, p.latitude)::geography,
  ST_MakePoint(user_longitude, user_latitude)::geography,
  50000  -- 50km in meters
)
```

### Interest-Based Scoring

Calculate compatibility score based on shared interests:

```python
def calculate_interest_score(user_interests, profile_interests):
    if not user_interests or not profile_interests:
        return 0
    
    shared = set(user_interests) & set(profile_interests)
    total = set(user_interests) | set(profile_interests)
    
    return len(shared) / len(total) if total else 0
```

### ML-Based Recommendations

Future Python microservice could implement:

1. **Collaborative Filtering**
   - Users who liked similar profiles
   - Users with similar swipe patterns

2. **Content-Based Filtering**
   - Bio text analysis (NLP)
   - Interest matching
   - Age compatibility

3. **Hybrid Approach**
   - Combine collaborative + content-based
   - Weighted scoring system
   - A/B testing different algorithms

### Matching Algorithm Service Design

```python
# Future service structure
class MatchingService:
    def get_recommendations(
        self,
        user_id: str,
        limit: int = 20,
        filters: Optional[MatchFilters] = None
    ) -> List[ProfileRecommendation]:
        """
        Returns ranked list of profile recommendations.
        
        Scoring factors:
        - Location proximity (0-1)
        - Interest overlap (0-1)
        - Age compatibility (0-1)
        - Activity level (0-1)
        - ML prediction score (0-1)
        
        Final score = weighted average
        """
        pass
    
    def calculate_compatibility(
        self,
        user_a: Profile,
        user_b: Profile
    ) -> float:
        """Returns compatibility score 0-1"""
        pass
```

### Ranking Factors

1. **Proximity** (30% weight)
   - Closer users ranked higher
   - Max distance: 100km (configurable)

2. **Interest Overlap** (25% weight)
   - Shared interests boost score
   - More overlap = higher score

3. **Activity Level** (15% weight)
   - Recent activity = higher score
   - Active users more likely to respond

4. **Age Compatibility** (10% weight)
   - Age difference factor
   - Preference for similar age ranges

5. **ML Prediction** (20% weight)
   - Historical match success
   - User behavior patterns
   - Response rate predictions

### A/B Testing Framework

Test different matching algorithms:

- **Variant A**: Current simple mutual-like
- **Variant B**: Location + interest-based
- **Variant C**: Full ML-based recommendations

Track metrics:
- Match rate
- Message initiation rate
- User retention
- Time to first match

## Implementation Notes

### Database Triggers

Current trigger automatically creates matches on mutual likes:

```sql
create trigger on_mutual_like
  after insert on public.likes
  for each row
  execute function public.handle_mutual_like();
```

### Extension Points

1. **Edge Function**: Supabase Edge Function for matching logic
2. **Python Service**: Separate microservice for complex algorithms
3. **Caching**: Redis cache for recommendation results
4. **Queue**: Background job queue for batch matching

### Performance Considerations

- Index on `profiles(latitude, longitude)` for location queries
- Index on `profiles(created_at)` for discovery ordering
- Consider pagination for large user bases
- Cache frequently accessed profiles

