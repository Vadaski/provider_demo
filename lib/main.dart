import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerdemo/model/counter_model.dart';
import 'bloc/counter_page_bloc.dart';
import 'impl/counter_impl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 架构探索',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

//每一个页面或者领域提供一个 HomePageBlocProvider 以提供这个页面所需要的状态数据
class HomePageBlocProvider extends StatelessWidget {
  final Widget child;

  HomePageBlocProvider({@required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //提供实际model
        Provider<CounterPageBloc>(
          create: (_) => CounterPageBloc()..init(),
          dispose: (_, CounterPageBloc bloc) => bloc.dispose(),
        ),
        //转化成 ViewModel 提供
        ProxyProvider<CounterPageBloc, CounterImpl>(
          update: (_, counterBloc, __) => counterBloc,
        )
      ],
      child: child,
    );
  }
}

// 页面级别 widget
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //提供数据Model
    return HomePageBlocProvider(
      child: Scaffold(
        body: Center(child: CounterWidget()),
        floatingActionButton: CounterButton(),
      ),
    );
  }
}

//子组件
class CounterButton extends StatefulWidget {
  @override
  _CounterButtonState createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  //依赖于接口
  CounterImpl bloc;

  @override
  void initState() {
    super.initState();
    //获取 model，由于不是 listen，所以可以在 init 中获得
    bloc = Provider.of<CounterImpl>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: () {
      bloc.increment();
    });
  }
}

class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //由于使用的 stream builder 它的刷新范围非常方便控制，并且和实际业务模型解藕
    return StreamBuilder(
      stream: Provider.of<CounterImpl>(context).counterModel,
      builder: (context, AsyncSnapshot<CounterModel> snapshot) {
        if (!snapshot.hasData) return Container();
        return Text(
          '${snapshot.data.value}',
          style: TextStyle(color: Colors.black),
        );
      },
    );
  }
}
