<#
  This is another way of loading xml documents
    $Catalog = New-Object -TypeName xml
    $Catalog.Load('.\Books-sample.xml')
#>


[xml]$Catalog = get-content .\Books-sample.xml

### XPATH QUERIES
# / - search from current position in the DOM
# Take note of the structure when lookin at the results
# - Notice the difference between the attibute "id" and the elements "author, title, genre..."
$Catalog.SelectNodes("/bookshelf/book[price>30]")
$Catalog.SelectNodes("/bookshelf/book[author='Galos, Mike']")

# Notice that searching in XML is case sensitive, this yeild no results
$Catalog.SelectNodes("/bookshelf/book[author='galos, mike']")

# This will get the last node in the current bookshelf so we can increment the id number
# for the new book that is just about to be created
$LastBook = $Catalog.SelectSingleNode('/bookshelf/book[last()]')
$LastIdNumber = ($LastBook.id -replace '[^0-9]','') -as [int]



## This section shows us how to create a new node, attribute and sub elements
# Create new Book
$parent = $Catalog.SelectSingleNode('/bookshelf')
$child = $Catalog.CreateElement('element','book','')
$parent.AppendChild($child)

# Find New Book
# This located the book element that we just created in the previous code block
$NewBook = $Catalog.SelectSingleNode('/bookshelf/book[last()]')  

# Add structure 
# Note the structure does not include the attribute "id"
$author  = $Catalog.CreateElement('element','author','')
$title   = $Catalog.CreateElement('element','title','')
$genre   = $Catalog.CreateElement('element','genre','')
$price   = $Catalog.CreateElement('element','price','')
$PubDate = $Catalog.CreateElement('element','publish_date','')
$Desc    = $Catalog.CreateElement('element','description','')

# Append a strucure to the new book
# Note that we do not add the "id" attribute here, as these are elements
$NewBook.AppendChild($author)
$NewBook.AppendChild($title)
$NewBook.AppendChild($genre)
$NewBook.AppendChild($price)
$NewBook.AppendChild($PubDate)
$NewBook.AppendChild($Desc)

$LastBook = $Catalog.SelectSingleNode('/bookshelf/book[last()]')

# Populate the new "empty" book info with data
# Notice how the attribute "id" is set at the start of this code block
$NextIdNumber = 'bk' + ($LastIdNumber + 1)
$LastBook.SetAttribute('id', $NextIdNumber)
$LastBook.author = 'Denny, Brent'
$LastBook.title = 'The Life of a scripter'
$LastBook.genre = 'IT'
$LastBook.price = '10.34'
$LastBook.publish_date = '2018-01-22'
$LastBook.Description = 'How to get things done while you are asleep. Getting your weekends back from the clutches of IT support'

# Save the modified XML data to a file
$Catalog.Save(".\UpdatedBookList.xml")
