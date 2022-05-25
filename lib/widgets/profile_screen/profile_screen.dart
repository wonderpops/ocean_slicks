import 'package:flutter/material.dart';
import 'package:ocean_slicks/constants/colors.dart';
import 'package:ocean_slicks/widgets/post_screen/post_screen.dart';

class ProfileScreenWidget extends StatefulWidget {
  const ProfileScreenWidget({Key? key}) : super(key: key);

  @override
  State<ProfileScreenWidget> createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Widget> posts = [
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget()
  ];

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    // Theme.of(context).scrollbarTheme.thumbColor
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    children: [_HeadNavigationWidget(), _UserInfoWidget()],
                  ),
                  color: gray_color,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: light_color,
                  child: TabBar(
                    labelColor: accent_color,
                    indicatorColor: secondary_color,
                    unselectedLabelColor: dark_color.withOpacity(.6),
                    controller: _tabController,
                    tabs: [
                      Tab(
                        text: 'Public',
                      ),
                      Tab(
                        text: 'Private',
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Container(
            color: light_color,
            child: TabBarView(
              children: [
                _UserPostsWidget(
                  posts: posts,
                ),
                _UserPostsWidget(
                  posts: posts,
                )
              ],
              controller: _tabController,
            ),
          ),
        ));
  }
}

class _HeadNavigationWidget extends StatelessWidget {
  const _HeadNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Icon(
                  Icons.settings_outlined,
                  color: dark_color.withOpacity(.6),
                  size: 40,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => print('lol'),
                    splashColor: accent_color.withOpacity(.1),
                    hoverColor: accent_color.withOpacity(.1),
                    focusColor: accent_color.withOpacity(.1),
                    highlightColor: accent_color.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _UserInfoWidget extends StatelessWidget {
  const _UserInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: secondary_color,
          child: Icon(
            Icons.person_outline_outlined,
            color: Colors.white,
            size: 50,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'wonderpop',
          style: TextStyle(color: dark_color.withOpacity(.8), fontSize: 26),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'user info',
          style: TextStyle(color: dark_color.withOpacity(.8), fontSize: 20),
        ),
      ]),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class _UserPostsWidget extends StatelessWidget {
  _UserPostsWidget({Key? key, required this.posts}) : super(key: key);
  List<Widget> posts;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: accent_color,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: ListView(
                  children: posts,
                ),
              ))),
    );
  }
}

class _PostWidget extends StatelessWidget {
  const _PostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: secondary_color,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: dark_color,
                        radius: 26,
                        child: Icon(
                          Icons.person,
                          color: light_color,
                        ),
                      ),
                      SizedBox(width: 18),
                      Text(
                        'username',
                        style: TextStyle(
                            color: dark_color.withOpacity(.8), fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(height: 300, child: Placeholder()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Title',
                          style: TextStyle(
                              color: dark_color.withOpacity(.8), fontSize: 24),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: accent_color.withOpacity(.1)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '18-02-1998',
                              style: TextStyle(
                                  color: accent_color.withOpacity(.6),
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        PostScreenWidget(post_id: 0),
                  ),
                );
                print('lol');
              },
              splashColor: accent_color.withOpacity(.1),
              hoverColor: accent_color.withOpacity(.1),
              focusColor: accent_color.withOpacity(.1),
              highlightColor: accent_color.withOpacity(.1),
              borderRadius: BorderRadius.circular(20),
            ),
          ))
        ],
      ),
    );
  }
}
