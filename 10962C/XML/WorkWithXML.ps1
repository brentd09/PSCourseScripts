[xml]$Books = get-content .\Books-sample.xml

### XPATH QUERIES
$books.SelectNodes("/catalog/book[price=36.95]")
$books.SelectNodes("/catalog/book[author='Galos, Mike']")

$parent = $Books.SelectSingleNode('//catalog')
$child = $books.CreateElement('element','book','')
$parent.AppendChild($child)

$parent = $Books.SelectSingleNode('/catalog/book[last()]')  
$id = $books.CreateElement('element','id','')
$author = $books.CreateElement('element','author','')
$title = $books.CreateElement('element','title','')
$genre = $books.CreateElement('element','genre','')
$price = $books.CreateElement('element','price','')
$PubDate = $books.CreateElement('element','published_date','')
$Desc = $books.CreateElement('element','description','')
$parent.AppendChild($id)
$parent.AppendChild($author)
$parent.AppendChild($title)
$parent.AppendChild($genre)
$parent.AppendChild($price)
$parent.AppendChild($PubDate)
$parent.AppendChild($Desc)

$Books.SelectSingleNode('/catalog/book[last()]').id = 'bk113'
$Books.SelectSingleNode('/catalog/book[last()]').author = 'Denny, Brent'
$Books.SelectSingleNode('/catalog/book[last()]').title = 'The Life of a scripter'
$Books.SelectSingleNode('/catalog/book[last()]').genre = 'IT'
$Books.SelectSingleNode('/catalog/book[last()]').price = '10.34'
$Books.SelectSingleNode('/catalog/book[last()]').published_date = '2018-01-22'
$Books.SelectSingleNode('/catalog/book[last()]').Description = 'A really boring book'

$books.Save("C:\Users\Administrator\Documents\newbooks.xml")
