# ASP.NET Core 8 - Lists in View with jQuery

Suppose there are two models, `Bill` and `BillDetail`. Where `BillDetail` is a `List<BillDetail>` object of the `Bill` model. A user creating a bill needs to be able to add details to the bill dynamically. Each Bill can have 0 or more details attached to it. Each model is backed by a table in a database. 

```csharp
public class Bill()
{
    public int Id { get; set;}
    public string BillToUser {get; set;}
    public string BillToAddress {get; set;}
    public int BillTotal {get; set;}
    public List<BillDetail> BillDetailsList {get; set;}
}

public class BillDetail()
{
    public int Id {get; set;}
    public string LineItemName {get; set;}
    public int LineItemQuantity {get; set;}
    public int LineItemCost {get; set;}
}
```

For this case, we are assuming that the `Bill` record already exists in the database, a user is editing the `Bill` to add 0 or more `BillDetails` to it. The `GET` Edit controller is defined as follows: 

```csharp
// GET: Bill/Edit/5
public async Task<ActionResult> Edit(int? id)
{
    if (id == null || id == 0)
    {
        return NotFound();
    }
    var bill = await _repository.queries.GetBillWithDetails(id.Value);
    if(bill == null)
    {
        return NotFound();
    }

    if (bill.BillDetailsList.Any() == false)
    {
        bill.BillDetailsList.Add(new BillDetail());
    }
    return View(billoflading);
}
```

This allows `Bill` to be displayed even if there are no `BillDetail` items within it. 

Within the Edit View, use a `for` loop to iterate over your `BillDetails` list. This way we can keep track of the index value for each item in the list. Wrap your `for` loop in a div with a unique ID value so jQuery can access it later. 

```cs
<form asp-action="Edit" id="BillForm">

// HTML to render Bill

<div id="BillDetailsListBlock">
@foreach(var detail in Bill.BillDetailsList)
{
    <div class="d-flex flex-row row-lg gap-3 g-3 BillDetailRow">
    <div asp-validation-summary="ModelOnly" class="text-danger"></div>
    <input type="hidden" asp-for="@Model.BillDetailsList[i].Id" />
    <div class="form-group">
        <label asp-for="@Model.BillDetailsList[i].LineItemName" class="control-label"></label>
        <input asp-for="@Model.BillDetailsList[i].LineItemName" class="form-control"/>
        <span asp-validation-for="@Model.BillDetailsList[i].LineItemName" class="text-danger"></span>
    </div>
    //..Remaining HTML to render your model here... 
}

<button type="button" id="addBillDetailRow" class="btn btn-primary btn-sm">Add Bil Details</button>

</div>

//Remaining Bill HTML

<div class="d-flex flex-row row-sm justify-content-center">
    <div class="d-flex flex-column col-sm-2">
        <div class="form-group">
            <input type="submit" value="Save" class="btn btn-primary" />
        </div>
    </div>
</div>
</form>
```

The real 'magic' is in the javascript for this section: 

```js
$(document).ready(function() {
            $("#addBillDetailRow").on('click', addBolDetailsRow);
        });
        
        const addBolDetailsRow = () => {
            // Clone the partial page template
            var newItem = $('.BillDetailRow').first().clone();

            // Clear input values in the cloned row
            newItem.find('input').val('');

            // Update input field names for the new item
            var newIndex = $('.BillDetailRow').length; // Calculate the next index
            newItem.find('input').each(function() {
                var name = $(this).attr('name');
                // Update input field names based on the index
                name = name.replace('[0]', '[' + newIndex + ']');
                $(this).attr('name', name);
            });

            // Append the new item to the DOM
            $('#BillDetailsBlock').append(newItem);
        };

        // Handler for removing dynamically added rows
        $(document).on('click', '.btn-danger', function() {
            $(this).closest('.BillDetailRow').remove();
        });
```

Now when the form is submitted all of the items within our list are added into the form, provided the rest of the model is valid. 

> NOTE: This does not handle deleting items that already exist in the database. The code above will only remove the HTML from the page when the "remove" button is clicked. If the Detail item didn't exist in the database, then no harm done. Else, if "removed" from the page, upon form submission, it will still be present in the database and not get removed. 