[back](./README.md)

# ASP.NET Core 8 - Lists in View with jQuery

When creating a form, if you are using jQuery/JS to add some user interactivity on the page and posting that information to a local .NET API class. There are a few caveats to watch out for: 

- in jQuery, ensure your parameter names match the method parameters. If your API method is defined like so: 

```chsarp
[HttpPost]
[Route("DeleteFile")]
public async Task<IActionResult> DeleteAttachedFile(
    [FromForm] int id)
    {
        // method definiton
    }
```

Then your jQuery method must also pass the `id` parameter named as `id`. Else the values will not map at all and your API class will see no, or null values passed to it. 

- When POST-ing values from jQuery, ensure your method parameters are prefixed with `[FromForm]` attributes. Else your values might get passed in jQuery, but .NET will not see the values. 

## Example

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
    //using CQRS pattern, but any DbContext<T> will do: 
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
> While the above code does indeed work for most situations, it is better practice to use an existing template (sting literal in JS or CSHTML partial) and input values into that rather than overwriting existing ones. 

The current code does essentially this:

- Clone the dirtied first item and append to the end
- Modify the dirtied first item to make it clean again

It would be better to use a clean prototype / template from which you can easily create clean new instances. Then the operations can become:

- Move the dirtied first item to the end
- Recreate the first item from the clean template

The first approach is not so good, because:

- Cloning is always a suspicious operation. For example, you have to make sure that:
        all fields correctly copied
        no references accidentally leaked
        deep objects correctly deep-copied: although this is not a concern in this specific example, but I'm adding it anyway as a reminder of general concerns about the concept of cloning
- Reseting an object to a clean state is always a suspicious operation. For example, you have to make sure that:
        all fields are correctly reset: often duplicating the same logic that must exist (explicitly or implicitly) in the initializer / constructor

The new approach doesn't have any of these tricky issues. It's conceptually much cleaner, with much fewer hidden traps and bugs waiting to happen.


Now when the form is submitted all of the items within our list are added into the form, provided the rest of the model is valid. 

See: [this](https://codereview.stackexchange.com/questions/69295/better-way-of-clone-and-then-replace-some-attributes-with-jquery) codereview.stackexchange post

Example duplicating HTML using string literal template: 

```javascript
    let currentIndex = @Model.Items.Count;
    const duplicateRow = (jsonResponse) => {
        console.log("index: ", currentIndex);
        let newRow = `<div class="QItemsRow">
                    <div class="d-flex flex-row row-sm-6 gap-3" style="padding: 2%" id="${jsonResponse.qitemsId}">
                        <input name="Items[${currentIndex}].QitemsId" style="display:none" value="0" />
                        <div class="form-group">
                            <label for="Items[${currentIndex}].QitemsItemId" class="control-label">Item ID</label>
                            <input id="Items_${currentIndex}__QitemsItemId" name="Items[${currentIndex}].QitemsItemId" class="form-control" style="display: none" value="${jsonResponse.qitemsItemId}"/>
                            <p>${jsonResponse.qitemsItemId}</p>
                            <span id="Items[${currentIndex}].QitemsItemId" class="text-danger"></span>
                        </div>
                        <div class="form-group">
                            <label for="Items[${currentIndex}].QitemsPricesDesc" class="control-label">Description</label>
                            <input id="Items_${currentIndex}__QitemsPricesDesc" name="Items[${currentIndex}].QitemsPricesDesc" class="form-control" value="${jsonResponse.qitemsPricesDesc}" />
                            <span for="Items[${currentIndex}].QitemsPricesDesc" class="text-danger"></span>
                        </div>
                        <div class="form-group">
                            <label for="Items[${currentIndex}].QitemsQuantity" class="control-label">Quantity</label>
                            <input id="Items_${currentIndex}__QitemsQuantity" name="Items[${currentIndex}].QitemsQuantity" class="form-control" value="${jsonResponse.qitemsQuantity}" />
                            <span for="Items[${currentIndex}].QitemsQuantity" class="text-danger"></span>
                        </div>
                        <div class="form-group">
                            <label for="Items[${currentIndex}].QitemsSaleQty" class="control-label">Sale Quantity</label>
                            <input id="Items_${currentIndex}__QitemsSaleQty" name="Items[${currentIndex}].QitemsSaleQty" type="number" class="form-control" value="${jsonResponse.qitemsSaleQty}" />
                            <span for="Items[${currentIndex}].QitemsSaleQty" class="text-danger"></span>
                        </div>
                        <div class="form-group">
                            <label for="Items[${currentIndex}].QitemsPrice" class="control-label">Price</label>
                            <input id="Items_${currentIndex}__QitemsPrice" name="Items[${currentIndex}].QitemsPrice" type="number" class="form-control" value="${jsonResponse.qitemsPrice}" />
                            <span for="Items[${currentIndex}].QitemsPrice" class="text-danger"></span>
                        </div>
                        <div class="form-group">
                            <label for="Items[${currentIndex}].QitemsSaleValue" class="control-label">Sale Value</label>
                            <input id="Items_${currentIndex}__QitemsSaleValue" name="Items[${currentIndex}].QitemsSaleValue" type="number" class="form-control" value="${jsonResponse.qitemsSaleValue}" />
                            <span for="Items[${currentIndex}].QitemsSaleValue" class="text-danger"></span>
                        </div>
                    </div>
                    </div>`;
        
        // Append the new row to the container
        $(".QItemsRow:last").after(newRow);
        currentIndex++; // Increment the index
    }
```

For the above template and ASP.NET it's important to note that you will have to set the ID and Name fields by hand in your template, `asp-for` does not exist in this context and javascript will put your exact string literal into the page's HTML. Without these attributes set exactly as your controller/model is expecting, the values will not POST. 

## Remove items from list

Finally worked out a hacky solution for removing items from this list. Basically store all the ID's of the item that was removed in a hidden input field. Send back that list on form submission, convert the hidden input field into a `List<string>` then iterate over this list and remove the items by their ID. 

Start with the `cshtml` page and add a hidden input anywhere wihtin the existing `<form>` block.

`<input type="hidden" id="BoLDetailsToRemove" name="BoLDetailsToRemove" value="" />`

Give your input an ID, name and empty value. Use this to store your ID's that have been removed. 

Add a new javascript function to grap the ID of the item removed and append it to our list. I used comma separation foreach item: 

```javascript
// Handler for removing dynamically added rows
$(document).on('click', '.btn-danger', function() {
    //$(this).closest('.BoLDetailRow').remove();
    let row = $(this).closest('.BoLDetailRow');
    let index = row.index();
    console.log(row);
    let BoLId = $('#BolDetailsList_' + index + '__Id').val();
    console.log(BoLId);
    let BoLDetailsToRemove = $('#BoLDetailsToRemove');
    BoLDetailsToRemove.val(BoLDetailsToRemove.val() + BoLId + ',');
    row.remove();
    console.log($('#BoLDetailsToRemove').val());
```

The controller method is updated to accept the new input as a string value. If the string has any data in it, it gets converted into a `List<string>` separated by the `,` separating each item. This list gets sent to the repository to be removed. The repository was updated to accept a new paramenter of `List<string>`, but it is defaulted to null. 

```csharp
public async Task<ActionResult> Edit(int? id, [FromForm]string? BoLDetailsToRemove, BoLViewModel model)
{
    if(id != model.BolId)
    {
        model.ErrorMessage = "ID mismatch";
        return View(model);
    }

    if (ModelState.IsValid)
    {
        if (!string.IsNullOrEmpty(BoLDetailsToRemove))
        {
            //split the list if it's not null: 
            var boLDetailsToRemoveList = BoLDetailsToRemove.Split(",").ToList();
            var result = await _repository.commands.EditBillOfLading(model, boLDetailsToRemoveList);
            if (!string.IsNullOrEmpty(result.ErrorMessage))
            {
                _logger.LogError($"Error returned: {result.ErrorMessage}");
                model.ErrorMessage = result.ErrorMessage;
                return View(model);
            }
        }
        else
        {
            //continue as normal if no details were removed: 
            var result = await _repository.commands.EditBillOfLading(model);
            if (!string.IsNullOrEmpty(result.ErrorMessage))
            {
                _logger.LogError($"Error returned: {result.ErrorMessage}");
                model.ErrorMessage = result.ErrorMessage;
                return View(model);
            }
        }
```