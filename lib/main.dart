import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Graph Keu El",
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink("https://countries.trevorblades.com/");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
        GraphQLClient(link: httpLink, cache: GraphQLCache()));
    return GraphQLProvider(
      child: HomePage(),
      client: client,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String q = """
        query{
          countries{
            name
              }
       }""";
    return Scaffold(
        appBar: AppBar(
          title: const Text("Graph Keu El"),
        ),
        body: Query(
            options: QueryOptions(document: gql(q)),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              int c = result.data?["countries"]?.length;
              if(result != null){
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                      itemCount: c,
                      itemBuilder: (BuildContext context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("${index+1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                                  const SizedBox(width: 15,),
                                  Expanded(child: Text(result.data!["countries"][index]['name'], style: const TextStyle(letterSpacing: 2, fontSize: 17), overflow: TextOverflow.clip,)),
                                  const SizedBox(height: 30,)
                                ],
                              ),
                            ),
                            Divider(height: 2, thickness: 2,)
                          ],
                        );
                      }),
                );
              }
              return const Center(child: CircularProgressIndicator(),);
            }));
  }
}
