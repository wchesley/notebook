# C# Snippits

Helpful, reusable, generic bits of code that can be placed in any project based on the snippets use and projects needs.

## Truncate String

```csharp
public static class TruncateString
{
    /// <summary>
    /// Truncate a string to a specified length
    /// </summary>
    /// <param name="value">String to truncate</param>
    /// <param name="maxLength">Maximum length of string</param>
    /// <returns>Truncated string value.</returns>
    public static string? Truncate(this string? value, int maxLength)
    {
        return value?.Length > maxLength 
            ? value.Substring(0, maxLength) 
            : value;
    }
}
```

## Validate IPv4 Address

```csharp
/// <summary>
/// Tests string to see if it is valid IPv4 address
/// </summary>
/// <param name="ip">String to test</param>
/// <returns>True if string is IP address, False otherwise</returns>
private bool ValidateIpv4Address(string ip)
{
    IPAddress address;
    return ip != null && ip.Count(c => c == '.') == 3 &&
           IPAddress.TryParse(ip, out address); 
}
```

## Trim Whitespace from all string properties in a give class

```csharp
/// <summary>
/// Trims the whitespace all string properties of the current instance.
/// </summary>
/// <remarks>
/// This method uses reflection to find all properties of the current instance that are of type string and can be read and written.
/// For each such property, it gets the current value, trims it, and then sets the trimmed value back to the property.
/// If the current value of the property is null, it is skipped.
/// </remarks>
public void Trim()
{
    // Get all string properties of the current instance that can be read and written.
    var stringProperties = this.GetType().GetProperties().Where(
        p => p.PropertyType == typeof(string)
                && p.CanWrite
                && p.CanRead);

    // For each such property...
    foreach (var property in stringProperties)
    {
        // Get the current value of the property.
        var value = (string)property.GetValue(
            this,
            null);

        // If the current value is null, skip this property.
        if (value is null)
        {
            continue;
        }

        // Trim the current value.
        value = value.Trim();

        // Set the trimmed value back to the property.
        property.SetValue(
            this,
            value,
            null);
    }
}
```

## Lambda LINQ - Filter by multiple keywords
###### [Source](https://stackoverflow.com/questions/67666649/lambda-linq-with-contains-criteria-for-multiple-keywords/67666993#67666993)

Concept behind this is that it takes the `filterPattern` and basically builds up an expression that applies that to each value in the `items` and then or's them together. So the example below would create an expression equivalent to `m => m.Comments.Contains(keyword1) || m.Comments.Contains(keyword2) || m.Comments.Contains(keyword3)` where keywords contains `keyword1`, `keyword2`, and `keyword3`

```csharp
public static class QueryableExtensions
{
    public static IQueryable<T> FilterByItems<T, TItem>(this IQueryable<T> query, IEnumerable<TItem> items,
        Expression<Func<T, TItem, bool>> filterPattern, bool isOr)
    {
        Expression predicate = null;
        foreach (var item in items)
        {
            var itemExpr = Expression.Constant(item);
            var itemCondition = ExpressionReplacer.Replace(filterPattern.Body, filterPattern.Parameters[1], itemExpr);
            if (predicate == null)
                predicate = itemCondition;
            else
            {
                predicate = Expression.MakeBinary(isOr ? ExpressionType.OrElse : ExpressionType.AndAlso, predicate,
                    itemCondition);
            }
        }

        predicate ??= Expression.Constant(false);
        var filterLambda = Expression.Lambda<Func<T, bool>>(predicate, filterPattern.Parameters[0]);

        return query.Where(filterLambda);
    }

    class ExpressionReplacer : ExpressionVisitor
    {
        readonly IDictionary<Expression, Expression> _replaceMap;

        public ExpressionReplacer(IDictionary<Expression, Expression> replaceMap)
        {
            _replaceMap = replaceMap ?? throw new ArgumentNullException(nameof(replaceMap));
        }

        public override Expression Visit(Expression exp)
        {
            if (exp != null && _replaceMap.TryGetValue(exp, out var replacement))
                return replacement;
            return base.Visit(exp);
        }

        public static Expression Replace(Expression expr, Expression toReplace, Expression toExpr)
        {
            return new ExpressionReplacer(new Dictionary<Expression, Expression> { { toReplace, toExpr } }).Visit(expr);
        }

        public static Expression Replace(Expression expr, IDictionary<Expression, Expression> replaceMap)
        {
            return new ExpressionReplacer(replaceMap).Visit(expr);
        }

        public static Expression GetBody(LambdaExpression lambda, params Expression[] toReplace)
        {
            if (lambda.Parameters.Count != toReplace.Length)
                throw new InvalidOperationException();

            return new ExpressionReplacer(Enumerable.Range(0, lambda.Parameters.Count)
                .ToDictionary(i => (Expression) lambda.Parameters[i], i => toReplace[i])).Visit(lambda.Body);
        }
    }
}

```

Usage: 

```chsarp
var newList = MainList
   .FilterByItems(keywords, (m, k) => m.Comments.Contains(k), true)
   .ToList();
```