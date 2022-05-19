import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../constants/colors.dart';

class SearchScreenWidget extends StatelessWidget {
  const SearchScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: gray_color,
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: accent_color,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [_SearchWidget(), _SearchResultsWidget()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                keyboardType: TextInputType.text,
                style: TextStyle(color: dark_color.withOpacity(.8)),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  suffixIcon: Icon(
                    Icons.search_rounded,
                    color: dark_color.withOpacity(.8),
                  ),
                  labelStyle: TextStyle(color: dark_color.withOpacity(.4)),
                  hintStyle: TextStyle(color: dark_color.withOpacity(.1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(.4))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: dark_color.withOpacity(.4)),
                  ),
                  labelText: 'Search...',
                  hintText: 'Search',
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  width: 55,
                  height: 55,
                  child: Icon(
                    Icons.filter_alt_outlined,
                    color: dark_color.withOpacity(.8),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      print('lol');
                    },
                    splashColor: Colors.white.withOpacity(.1),
                    hoverColor: Colors.white.withOpacity(.1),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      alignment: Alignment.center,
                      width: 55,
                      height: 55,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultsWidget extends StatelessWidget {
  const _SearchResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
