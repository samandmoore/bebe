import 'package:bebe/src/data/auth/auth_repository.dart';
import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/kids/edit_kid_screen.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class KidSwitcherSliverAppBar extends StatelessWidget {
  const KidSwitcherSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      expandedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: KidSwitcher(),
        ),
      ),
    );
  }
}

class KidSwitcher extends ConsumerWidget {
  const KidSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kidsFetch = ref.watch(kidsProvider);
    if (kidsFetch.hasValue) {
      final kids = kidsFetch.value!;
      return KidSwitcherLoaded(
        kids: kids.toList(growable: false),
      );
    }
    return LoadingIndicator.white();
  }
}

class KidSwitcherLoaded extends ConsumerStatefulWidget {
  final List<Kid> kids;

  const KidSwitcherLoaded({
    super.key,
    required this.kids,
  });

  @override
  // ignore: library_private_types_in_public_api
  _KidSwitcherLoadedState createState() => _KidSwitcherLoadedState();
}

class _KidSwitcherLoadedState extends ConsumerState<KidSwitcherLoaded> {
  late List<Kid> kids;
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _setupKids();
    _currentIndex = kids.indexWhere((k) => k.isCurrent);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(KidSwitcherLoaded oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.kids != widget.kids) {
      _setupKids();
      _pageController.jumpToPage(_currentIndex);
    }
  }

  void _setupKids() {
    kids = widget.kids..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (value) async {
            final repo = ref.read(authRepositoryProvider);
            final kidToSelect = kids[value];

            setState(() => _currentIndex = value);
            await repo.updateCurrentKid(kidToSelect.id);
          },
          findChildIndexCallback: (key) => kids.indexWhere(
            (kid) => kid.id == (key as ValueKey<String>).value,
          ),
          itemCount: kids.length,
          itemBuilder: (context, index) {
            final kid = kids[index];
            return Center(
              key: ValueKey(kid.id),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          context.push(EditKidScreen.route, extra: kid);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          kid.name,
                          textScaleFactor: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        kid.toPrettyAge(),
                        style: const TextStyle(color: Colors.white),
                        textScaleFactor: 1.2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              kids.length,
              (index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: index == _currentIndex
                      ? Colors.white
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
