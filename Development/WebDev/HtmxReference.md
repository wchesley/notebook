# HTMX Reference

## [#](https://htmx.org/reference/#contents)Contents

-   [htmx Core Attributes](https://htmx.org/reference/#attributes)
-   [htmx Additional Attributes](https://htmx.org/reference/#attributes-additional)
-   [htmx CSS Classes](https://htmx.org/reference/#classes)
-   [htmx Request Headers](https://htmx.org/reference/#request_headers)
-   [htmx Response Headers](https://htmx.org/reference/#response_headers)
-   [htmx Events](https://htmx.org/reference/#events)
-   [htmx Extensions](https://htmx.org/extensions)
-   [JavaScript API](https://htmx.org/reference/#api)
-   [Configuration Options](https://htmx.org/reference/#config)

## [#](https://htmx.org/reference/#attributes)Core Attribute Reference

The most common attributes when using htmx.

Attribute

Description

[`hx-get`](https://htmx.org/attributes/hx-get/)

issues a `GET` to the specified URL

[`hx-post`](https://htmx.org/attributes/hx-post/)

issues a `POST` to the specified URL

[`hx-on*`](https://htmx.org/attributes/hx-on/)

handle events with inline scripts on elements

[`hx-push-url`](https://htmx.org/attributes/hx-push-url/)

push a URL into the browser location bar to create history

[`hx-select`](https://htmx.org/attributes/hx-select/)

select content to swap in from a response

[`hx-select-oob`](https://htmx.org/attributes/hx-select-oob/)

select content to swap in from a response, somewhere other than the target (out of band)

[`hx-swap`](https://htmx.org/attributes/hx-swap/)

controls how content will swap in (`outerHTML`, `beforeend`, `afterend`, …)

[`hx-swap-oob`](https://htmx.org/attributes/hx-swap-oob/)

mark element to swap in from a response (out of band)

[`hx-target`](https://htmx.org/attributes/hx-target/)

specifies the target element to be swapped

[`hx-trigger`](https://htmx.org/attributes/hx-trigger/)

specifies the event that triggers the request

[`hx-vals`](https://htmx.org/attributes/hx-vals/)

add values to submit with the request (JSON format)

## [#](https://htmx.org/reference/#attributes-additional)Additional Attribute Reference

All other attributes available in htmx.

Attribute

Description

[`hx-boost`](https://htmx.org/attributes/hx-boost/)

add [progressive enhancement](https://en.wikipedia.org/wiki/Progressive_enhancement) for links and forms

[`hx-confirm`](https://htmx.org/attributes/hx-confirm/)

shows a `confirm()` dialog before issuing a request

[`hx-delete`](https://htmx.org/attributes/hx-delete/)

issues a `DELETE` to the specified URL

[`hx-disable`](https://htmx.org/attributes/hx-disable/)

disables htmx processing for the given node and any children nodes

[`hx-disabled-elt`](https://htmx.org/attributes/hx-disabled-elt/)

adds the `disabled` attribute to the specified elements while a request is in flight

[`hx-disinherit`](https://htmx.org/attributes/hx-disinherit/)

control and disable automatic attribute inheritance for child nodes

[`hx-encoding`](https://htmx.org/attributes/hx-encoding/)

changes the request encoding type

[`hx-ext`](https://htmx.org/attributes/hx-ext/)

extensions to use for this element

[`hx-headers`](https://htmx.org/attributes/hx-headers/)

adds to the headers that will be submitted with the request

[`hx-history`](https://htmx.org/attributes/hx-history/)

prevent sensitive data being saved to the history cache

[`hx-history-elt`](https://htmx.org/attributes/hx-history-elt/)

the element to snapshot and restore during history navigation

[`hx-include`](https://htmx.org/attributes/hx-include/)

include additional data in requests

[`hx-indicator`](https://htmx.org/attributes/hx-indicator/)

the element to put the `htmx-request` class on during the request

[`hx-inherit`](https://htmx.org/attributes/hx-inherit/)

control and enable automatic attribute inheritance for child nodes if it has been disabled by default

[`hx-params`](https://htmx.org/attributes/hx-params/)

filters the parameters that will be submitted with a request

[`hx-patch`](https://htmx.org/attributes/hx-patch/)

issues a `PATCH` to the specified URL

[`hx-preserve`](https://htmx.org/attributes/hx-preserve/)

specifies elements to keep unchanged between requests

[`hx-prompt`](https://htmx.org/attributes/hx-prompt/)

shows a `prompt()` before submitting a request

[`hx-put`](https://htmx.org/attributes/hx-put/)

issues a `PUT` to the specified URL

[`hx-replace-url`](https://htmx.org/attributes/hx-replace-url/)

replace the URL in the browser location bar

[`hx-request`](https://htmx.org/attributes/hx-request/)

configures various aspects of the request

[`hx-sync`](https://htmx.org/attributes/hx-sync/)

control how requests made by different elements are synchronized

[`hx-validate`](https://htmx.org/attributes/hx-validate/)

force elements to validate themselves before a request

[`hx-vars`](https://htmx.org/attributes/hx-vars/)

adds values dynamically to the parameters to submit with the request (deprecated, please use [`hx-vals`](https://htmx.org/attributes/hx-vals/))

## [#](https://htmx.org/reference/#classes)CSS Class Reference

Class

Description

`htmx-added`

Applied to a new piece of content before it is swapped, removed after it is settled.

`htmx-indicator`

A dynamically generated class that will toggle visible (opacity:1) when a `htmx-request` class is present

`htmx-request`

Applied to either the element or the element specified with [`hx-indicator`](https://htmx.org/attributes/hx-indicator/) while a request is ongoing

`htmx-settling`

Applied to a target after content is swapped, removed after it is settled. The duration can be modified via [`hx-swap`](https://htmx.org/attributes/hx-swap/).

`htmx-swapping`

Applied to a target before any content is swapped, removed after it is swapped. The duration can be modified via [`hx-swap`](https://htmx.org/attributes/hx-swap/).

## [#](https://htmx.org/reference/#headers)HTTP Header Reference

### [#](https://htmx.org/reference/#request_headers)Request Headers Reference

Header

Description

`HX-Boosted`

indicates that the request is via an element using [hx-boost](https://htmx.org/attributes/hx-boost/)

`HX-Current-URL`

the current URL of the browser

`HX-History-Restore-Request`

“true” if the request is for history restoration after a miss in the local history cache

`HX-Prompt`

the user response to an [hx-prompt](https://htmx.org/attributes/hx-prompt/)

`HX-Request`

always “true”

`HX-Target`

the `id` of the target element if it exists

`HX-Trigger-Name`

the `name` of the triggered element if it exists

`HX-Trigger`

the `id` of the triggered element if it exists

### [#](https://htmx.org/reference/#response_headers)Response Headers Reference

Header

Description

[`HX-Location`](https://htmx.org/headers/hx-location/)

allows you to do a client-side redirect that does not do a full page reload

[`HX-Push-Url`](https://htmx.org/headers/hx-push-url/)

pushes a new url into the history stack

[`HX-Redirect`](https://htmx.org/headers/hx-redirect/)

can be used to do a client-side redirect to a new location

`HX-Refresh`

if set to “true” the client-side will do a full refresh of the page

[`HX-Replace-Url`](https://htmx.org/headers/hx-replace-url/)

replaces the current URL in the location bar

`HX-Reswap`

allows you to specify how the response will be swapped. See [hx-swap](https://htmx.org/attributes/hx-swap/) for possible values

`HX-Retarget`

a CSS selector that updates the target of the content update to a different element on the page

`HX-Reselect`

a CSS selector that allows you to choose which part of the response is used to be swapped in. Overrides an existing [`hx-select`](https://htmx.org/attributes/hx-select/) on the triggering element

[`HX-Trigger`](https://htmx.org/headers/hx-trigger/)

allows you to trigger client-side events

[`HX-Trigger-After-Settle`](https://htmx.org/headers/hx-trigger/)

allows you to trigger client-side events after the settle step

[`HX-Trigger-After-Swap`](https://htmx.org/headers/hx-trigger/)

allows you to trigger client-side events after the swap step

## [#](https://htmx.org/reference/#events)Event Reference

Event

Description

[`htmx:abort`](https://htmx.org/events/#htmx:abort)

send this event to an element to abort a request

[`htmx:afterOnLoad`](https://htmx.org/events/#htmx:afterOnLoad)

triggered after an AJAX request has completed processing a successful response

[`htmx:afterProcessNode`](https://htmx.org/events/#htmx:afterProcessNode)

triggered after htmx has initialized a node

[`htmx:afterRequest`](https://htmx.org/events/#htmx:afterRequest)

triggered after an AJAX request has completed

[`htmx:afterSettle`](https://htmx.org/events/#htmx:afterSettle)

triggered after the DOM has settled

[`htmx:afterSwap`](https://htmx.org/events/#htmx:afterSwap)

triggered after new content has been swapped in

[`htmx:beforeCleanupElement`](https://htmx.org/events/#htmx:beforeCleanupElement)

triggered before htmx [disables](https://htmx.org/attributes/hx-disable/) an element or removes it from the DOM

[`htmx:beforeOnLoad`](https://htmx.org/events/#htmx:beforeOnLoad)

triggered before any response processing occurs

[`htmx:beforeProcessNode`](https://htmx.org/events/#htmx:beforeProcessNode)

triggered before htmx initializes a node

[`htmx:beforeRequest`](https://htmx.org/events/#htmx:beforeRequest)

triggered before an AJAX request is made

[`htmx:beforeSwap`](https://htmx.org/events/#htmx:beforeSwap)

triggered before a swap is done, allows you to configure the swap

[`htmx:beforeSend`](https://htmx.org/events/#htmx:beforeSend)

triggered just before an ajax request is sent

[`htmx:beforeTransition`](https://htmx.org/events/#htmx:beforeTransition)

triggered before the [View Transition](https://developer.mozilla.org/en-US/docs/Web/API/View_Transitions_API) wrapped swap occurs

[`htmx:configRequest`](https://htmx.org/events/#htmx:configRequest)

triggered before the request, allows you to customize parameters, headers

[`htmx:confirm`](https://htmx.org/events/#htmx:confirm)

triggered after a trigger occurs on an element, allows you to cancel (or delay) issuing the AJAX request

[`htmx:historyCacheError`](https://htmx.org/events/#htmx:historyCacheError)

triggered on an error during cache writing

[`htmx:historyCacheMiss`](https://htmx.org/events/#htmx:historyCacheMiss)

triggered on a cache miss in the history subsystem

[`htmx:historyCacheMissError`](https://htmx.org/events/#htmx:historyCacheMissError)

triggered on a unsuccessful remote retrieval

[`htmx:historyCacheMissLoad`](https://htmx.org/events/#htmx:historyCacheMissLoad)

triggered on a successful remote retrieval

[`htmx:historyRestore`](https://htmx.org/events/#htmx:historyRestore)

triggered when htmx handles a history restoration action

[`htmx:beforeHistorySave`](https://htmx.org/events/#htmx:beforeHistorySave)

triggered before content is saved to the history cache

[`htmx:load`](https://htmx.org/events/#htmx:load)

triggered when new content is added to the DOM

[`htmx:noSSESourceError`](https://htmx.org/events/#htmx:noSSESourceError)

triggered when an element refers to a SSE event in its trigger, but no parent SSE source has been defined

[`htmx:onLoadError`](https://htmx.org/events/#htmx:onLoadError)

triggered when an exception occurs during the onLoad handling in htmx

[`htmx:oobAfterSwap`](https://htmx.org/events/#htmx:oobAfterSwap)

triggered after an out of band element as been swapped in

[`htmx:oobBeforeSwap`](https://htmx.org/events/#htmx:oobBeforeSwap)

triggered before an out of band element swap is done, allows you to configure the swap

[`htmx:oobErrorNoTarget`](https://htmx.org/events/#htmx:oobErrorNoTarget)

triggered when an out of band element does not have a matching ID in the current DOM

[`htmx:prompt`](https://htmx.org/events/#htmx:prompt)

triggered after a prompt is shown

[`htmx:pushedIntoHistory`](https://htmx.org/events/#htmx:pushedIntoHistory)

triggered after an url is pushed into history

[`htmx:responseError`](https://htmx.org/events/#htmx:responseError)

triggered when an HTTP response error (non-`200` or `300` response code) occurs

[`htmx:sendAbort`](https://htmx.org/events/#htmx:sendAbort)

triggered when a request is aborted

[`htmx:sendError`](https://htmx.org/events/#htmx:sendError)

triggered when a network error prevents an HTTP request from happening

[`htmx:sseError`](https://htmx.org/events/#htmx:sseError)

triggered when an error occurs with a SSE source

[`htmx:sseOpen`](https://htmx.org/events#htmx:sseOpen)

triggered when a SSE source is opened

[`htmx:swapError`](https://htmx.org/events/#htmx:swapError)

triggered when an error occurs during the swap phase

[`htmx:targetError`](https://htmx.org/events/#htmx:targetError)

triggered when an invalid target is specified

[`htmx:timeout`](https://htmx.org/events/#htmx:timeout)

triggered when a request timeout occurs

[`htmx:validation:validate`](https://htmx.org/events/#htmx:validation:validate)

triggered before an element is validated

[`htmx:validation:failed`](https://htmx.org/events/#htmx:validation:failed)

triggered when an element fails validation

[`htmx:validation:halted`](https://htmx.org/events/#htmx:validation:halted)

triggered when a request is halted due to validation errors

[`htmx:xhr:abort`](https://htmx.org/events/#htmx:xhr:abort)

triggered when an ajax request aborts

[`htmx:xhr:loadend`](https://htmx.org/events/#htmx:xhr:loadend)

triggered when an ajax request ends

[`htmx:xhr:loadstart`](https://htmx.org/events/#htmx:xhr:loadstart)

triggered when an ajax request starts

[`htmx:xhr:progress`](https://htmx.org/events/#htmx:xhr:progress)

triggered periodically during an ajax request that supports progress events

## [#](https://htmx.org/reference/#api)JavaScript API Reference

Method

Description

[`htmx.addClass()`](https://htmx.org/api/#addClass)

Adds a class to the given element

[`htmx.ajax()`](https://htmx.org/api/#ajax)

Issues an htmx-style ajax request

[`htmx.closest()`](https://htmx.org/api/#closest)

Finds the closest parent to the given element matching the selector

[`htmx.config`](https://htmx.org/api/#config)

A property that holds the current htmx config object

[`htmx.createEventSource`](https://htmx.org/api/#createEventSource)

A property holding the function to create SSE EventSource objects for htmx

[`htmx.createWebSocket`](https://htmx.org/api/#createWebSocket)

A property holding the function to create WebSocket objects for htmx

[`htmx.defineExtension()`](https://htmx.org/api/#defineExtension)

Defines an htmx [extension](https://htmx.org/extensions)

[`htmx.find()`](https://htmx.org/api/#find)

Finds a single element matching the selector

[`htmx.findAll()` `htmx.findAll(elt, selector)`](https://htmx.org/api/#find)

Finds all elements matching a given selector

[`htmx.logAll()`](https://htmx.org/api/#logAll)

Installs a logger that will log all htmx events

[`htmx.logger`](https://htmx.org/api/#logger)

A property set to the current logger (default is `null`)

[`htmx.off()`](https://htmx.org/api/#off)

Removes an event listener from the given element

[`htmx.on()`](https://htmx.org/api/#on)

Creates an event listener on the given element, returning it

[`htmx.onLoad()`](https://htmx.org/api/#onLoad)

Adds a callback handler for the `htmx:load` event

[`htmx.parseInterval()`](https://htmx.org/api/#parseInterval)

Parses an interval declaration into a millisecond value

[`htmx.process()`](https://htmx.org/api/#process)

Processes the given element and its children, hooking up any htmx behavior

[`htmx.remove()`](https://htmx.org/api/#remove)

Removes the given element

[`htmx.removeClass()`](https://htmx.org/api/#removeClass)

Removes a class from the given element

[`htmx.removeExtension()`](https://htmx.org/api/#removeExtension)

Removes an htmx [extension](https://htmx.org/extensions)

[`htmx.swap()`](https://htmx.org/api/#swap)

Performs swapping (and settling) of HTML content

[`htmx.takeClass()`](https://htmx.org/api/#takeClass)

Takes a class from other elements for the given element

[`htmx.toggleClass()`](https://htmx.org/api/#toggleClass)

Toggles a class from the given element

[`htmx.trigger()`](https://htmx.org/api/#trigger)

Triggers an event on an element

[`htmx.values()`](https://htmx.org/api/#values)

Returns the input values associated with the given element

## [#](https://htmx.org/reference/#config)Configuration Reference

Htmx has some configuration options that can be accessed either programmatically or declaratively. They are listed below:

Config Variable

Info

`htmx.config.historyEnabled`

defaults to `true`, really only useful for testing

`htmx.config.historyCacheSize`

defaults to 10

`htmx.config.refreshOnHistoryMiss`

defaults to `false`, if set to `true` htmx will issue a full page refresh on history misses rather than use an AJAX request

`htmx.config.defaultSwapStyle`

defaults to `innerHTML`

`htmx.config.defaultSwapDelay`

defaults to 0

`htmx.config.defaultSettleDelay`

defaults to 20

`htmx.config.includeIndicatorStyles`

defaults to `true` (determines if the indicator styles are loaded)

`htmx.config.indicatorClass`

defaults to `htmx-indicator`

`htmx.config.requestClass`

defaults to `htmx-request`

`htmx.config.addedClass`

defaults to `htmx-added`

`htmx.config.settlingClass`

defaults to `htmx-settling`

`htmx.config.swappingClass`

defaults to `htmx-swapping`

`htmx.config.allowEval`

defaults to `true`, can be used to disable htmx’s use of eval for certain features (e.g. trigger filters)

`htmx.config.allowScriptTags`

defaults to `true`, determines if htmx will process script tags found in new content

`htmx.config.inlineScriptNonce`

defaults to `''`, meaning that no nonce will be added to inline scripts

`htmx.config.inlineStyleNonce`

defaults to `''`, meaning that no nonce will be added to inline styles

`htmx.config.attributesToSettle`

defaults to `["class", "style", "width", "height"]`, the attributes to settle during the settling phase

`htmx.config.wsReconnectDelay`

defaults to `full-jitter`

`htmx.config.wsBinaryType`

defaults to `blob`, the [the type of binary data](https://developer.mozilla.org/docs/Web/API/WebSocket/binaryType) being received over the WebSocket connection

`htmx.config.disableSelector`

defaults to `[hx-disable], [data-hx-disable]`, htmx will not process elements with this attribute on it or a parent

`htmx.config.disableInheritance`

defaults to `false`. If it is set to `true`, the inheritance of attributes is completely disabled and you can explicitly specify the inheritance with the [hx-inherit](https://htmx.org/attributes/hx-inherit/) attribute.

`htmx.config.withCredentials`

defaults to `false`, allow cross-site Access-Control requests using credentials such as cookies, authorization headers or TLS client certificates

`htmx.config.timeout`

defaults to 0, the number of milliseconds a request can take before automatically being terminated

`htmx.config.scrollBehavior`

defaults to ‘instant’, the scroll behavior when using the [show](https://htmx.org/attributes/hx-swap/#scrolling-scroll-show) modifier with `hx-swap`. The allowed values are `instant` (scrolling should happen instantly in a single jump), `smooth` (scrolling should animate smoothly) and `auto` (scroll behavior is determined by the computed value of [scroll-behavior](https://developer.mozilla.org/en-US/docs/Web/CSS/scroll-behavior)).

`htmx.config.defaultFocusScroll`

if the focused element should be scrolled into view, defaults to false and can be overridden using the [focus-scroll](https://htmx.org/attributes/hx-swap/#focus-scroll) swap modifier.

`htmx.config.getCacheBusterParam`

defaults to false, if set to true htmx will append the target element to the `GET` request in the format `org.htmx.cache-buster=targetElementId`

`htmx.config.globalViewTransitions`

if set to `true`, htmx will use the [View Transition](https://developer.mozilla.org/en-US/docs/Web/API/View_Transitions_API) API when swapping in new content.

`htmx.config.methodsThatUseUrlParams`

defaults to `["get", "delete"]`, htmx will format requests with these methods by encoding their parameters in the URL, not the request body

`htmx.config.selfRequestsOnly`

defaults to `true`, whether to only allow AJAX requests to the same domain as the current document

`htmx.config.ignoreTitle`

defaults to `false`, if set to `true` htmx will not update the title of the document when a `title` tag is found in new content

`htmx.config.scrollIntoViewOnBoost`

defaults to `true`, whether or not the target of a boosted element is scrolled into the viewport. If `hx-target` is omitted on a boosted element, the target defaults to `body`, causing the page to scroll to the top.

`htmx.config.triggerSpecsCache`

defaults to `null`, the cache to store evaluated trigger specifications into, improving parsing performance at the cost of more memory usage. You may define a simple object to use a never-clearing cache, or implement your own system using a [proxy object](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Proxy)

`htmx.config.responseHandling`

the default [Response Handling](https://htmx.org/docs/#response-handling) behavior for response status codes can be configured here to either swap or error

`htmx.config.allowNestedOobSwaps`

defaults to `true`, whether to process OOB swaps on elements that are nested within the main response element. See [Nested OOB Swaps](https://htmx.org/attributes/hx-swap-oob/#nested-oob-swaps).

You can set them directly in javascript, or you can use a `meta` tag:

    <meta name="htmx-config" content='{"defaultSwapStyle":"outerHTML"}'>