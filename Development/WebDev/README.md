# WebDev

Related: 

- [dotnet](../dotnet/README.md)

## CSS 

To make a table column "freeze" or be sticky to the browsers view: 

```css
/* First column, sticks to the left */
th:first-child, td:first-child
{
  position:sticky;
  left:0px;
}
/* Last Column, sticks to the right */
th:last-child, td:last-child {
    position:sticky;
    right:0;
}
```