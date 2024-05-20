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