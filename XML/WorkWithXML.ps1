[xml]$Catalog = get-content .\Books-sample.xml

### XPATH QUERIES
# / - search from current position in the DOM
$Catalog.SelectNodes("/catalog/book[price]")
$Catalog.SelectNodes("/catalog/book[author='Galos, Mike']")

# Create new Book
$parent = $Catalog.SelectSingleNode('/catalog')
$child = $Catalog.CreateElement('element','book','')
$parent.AppendChild($child)

# Find New Book
$NewBook = $Catalog.SelectSingleNode('/catalog/book[last()]')  

# Add structure 
$id      = $Catalog.CreateElement('element','id','')
$author  = $Catalog.CreateElement('element','author','')
$title   = $Catalog.CreateElement('element','title','')
$genre   = $Catalog.CreateElement('element','genre','')
$price   = $Catalog.CreateElement('element','price','')
$PubDate = $Catalog.CreateElement('element','publish_date','')
$Desc    = $Catalog.CreateElement('element','description','')

# Append a strucure to the new book
$NewBook.AppendChild($id)
$NewBook.AppendChild($author)
$NewBook.AppendChild($title)
$NewBook.AppendChild($genre)
$NewBook.AppendChild($price)
$NewBook.AppendChild($PubDate)
$NewBook.AppendChild($Desc)

# Populate the last empty book info with data
$Catalog.SelectSingleNode('/catalog/book[last()]').id = 'bk113'
$Catalog.SelectSingleNode('/catalog/book[last()]').author = 'Denny, Brent'
$Catalog.SelectSingleNode('/catalog/book[last()]').title = 'The Life of a scripter'
$Catalog.SelectSingleNode('/catalog/book[last()]').genre = 'IT'
$Catalog.SelectSingleNode('/catalog/book[last()]').price = '10.34'
$Catalog.SelectSingleNode('/catalog/book[last()]').publish_date = '2018-01-22'
$Catalog.SelectSingleNode('/catalog/book[last()]').Description = 'A really boring book'

# Save the modified XML data to a file
$Catalog.Save("C:\Users\Administrator\Documents\newbooks.xml")
