[xml]$Books = get-content .\Books-sample.xml

### XPATH QUERIES
# / - search from current position in the DOM
$books.SelectNodes("/catalog/book[price=36.95]")
$books.SelectNodes("/catalog/book[author='Galos, Mike']")

# // search from the root of the DOM
$parent = $Books.SelectSingleNode('//catalog')
$child = $books.CreateElement('element','book','')
$parent.AppendChild($child)

# Find the last book from the XML data
$parent = $Books.SelectSingleNode('/catalog/book[last()]')  
$id = $books.CreateElement('element','id','')
$author = $books.CreateElement('element','author','')
$title = $books.CreateElement('element','title','')
$genre = $books.CreateElement('element','genre','')
$price = $books.CreateElement('element','price','')
$PubDate = $books.CreateElement('element','published_date','')
$Desc = $books.CreateElement('element','description','')

# Append a new book structure to the end of the XML
$parent.AppendChild($id)
$parent.AppendChild($author)
$parent.AppendChild($title)
$parent.AppendChild($genre)
$parent.AppendChild($price)
$parent.AppendChild($PubDate)
$parent.AppendChild($Desc)

# Populate the last empty book info with data
$Books.SelectSingleNode('/catalog/book[last()]').id = 'bk113'
$Books.SelectSingleNode('/catalog/book[last()]').author = 'Denny, Brent'
$Books.SelectSingleNode('/catalog/book[last()]').title = 'The Life of a scripter'
$Books.SelectSingleNode('/catalog/book[last()]').genre = 'IT'
$Books.SelectSingleNode('/catalog/book[last()]').price = '10.34'
$Books.SelectSingleNode('/catalog/book[last()]').published_date = '2018-01-22'
$Books.SelectSingleNode('/catalog/book[last()]').Description = 'A really boring book'

# Save the modified XML data to a file
$books.Save("C:\Users\Administrator\Documents\newbooks.xml")
