import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grostok/bloc/product/category-product/category_product_bloc.dart';
import 'package:grostok/core/const/app_assets.dart';
import 'package:grostok/core/const/app_colors.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:grostok/presentation/category/widgets/category_title_load.dart';
import 'package:grostok/widgets/debouncer.dart';
import 'package:grostok/widgets/product_list_load.dart';
import 'package:grostok/widgets/product_list_widget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isCategoryScroll = true;
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  List<String> categoryTitle = [];
  List<ProductData> products = [];
  final debouncer = Debouncer(milliseconds: 100);

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    scrollController.addListener(() {
      final bloc = context.read<CategoryProductBloc>();
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!bloc.state.isLoadingProduct && bloc.state.hasNextPage) {
          debouncer.run(
            () {
              bloc.add(
                  GetMoreProductByCategoryEvent(bloc.state.selectedCategory));
            },
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: scrollController,
        children: [
          searchBarTitle(searchController),
          SizedBox(height: 5),
          categoryFilter(context, categoryTitle, searchController),
          SizedBox(height: 10),
          listProduct(products),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Column searchBarTitle(TextEditingController searchController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBar(
          controller: searchController,
          backgroundColor: WidgetStatePropertyAll(AppColors.white),
          elevation: WidgetStatePropertyAll(0),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 15)),
          leading: SvgPicture.asset(
            AppAssets.searchIcon,
            colorFilter: ColorFilter.mode(AppColors.secondary, BlendMode.srcIn),
          ),
          hintText: 'Cari product disini..',
          hintStyle:
              WidgetStatePropertyAll(TextStyle(color: AppColors.secondary)),
          onChanged: (value) {
            debouncer.run(() => context
                .read<CategoryProductBloc>()
                .add(SearchProductEvent(value)));
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text("Category Product",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  AnimatedSize categoryFilter(BuildContext context, List<String> categoryTitle,
      TextEditingController searchController) {
    return AnimatedSize(
      duration: Duration(milliseconds: 100),
      alignment: Alignment.topCenter,
      child: isCategoryScroll
          ? categoryScroll(context, categoryTitle, searchController)
          : categoryWrap(context, categoryTitle, searchController),
    );
  }

  Container categoryWrap(BuildContext context, List<String> categoryTitle,
      TextEditingController searchController) {
    return Container(
      color: AppColors.background,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Semua Product", style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCategoryScroll = !isCategoryScroll;
                      });
                    },
                    child: Icon(Icons.keyboard_arrow_up_sharp,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: BlocBuilder<CategoryProductBloc, CategoryProductState>(
                builder: (context, state) {
                  if (state.categoryTitles.isNotEmpty) {
                    categoryTitle = state.categoryTitles;
                    return Wrap(
                      children: List.generate(
                        categoryTitle.length,
                        (index) {
                          return InkWell(
                            onTap: () {
                              if (!state.isLoadingProduct) {
                                searchController.clear();
                                context.read<CategoryProductBloc>().add(
                                    GetProductByCategoryEvent(
                                        categoryTitle[index]));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Material(
                                color: categoryTitle[index] ==
                                        state.selectedCategory
                                    ? AppColors.secondary
                                    : AppColors.background,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side:
                                        BorderSide(color: AppColors.secondary)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  child: Text(
                                    categoryTitle[index],
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: categoryTitle[index] ==
                                                state.selectedCategory
                                            ? AppColors.background
                                            : AppColors.secondary),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row categoryScroll(BuildContext context, List<String> categoryTitle,
      TextEditingController searchController) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: AppColors.background,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                child: BlocBuilder<CategoryProductBloc, CategoryProductState>(
                  builder: (context, state) {
                    if (state.isLoadingTitle) {
                      return CategoryTitleLoad();
                    }
                    if (state.isErrorTitle) {
                      return Center(child: Text("Error"));
                    }
                    if (state.categoryTitles.isNotEmpty) {
                      categoryTitle = state.categoryTitles;
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        categoryTitle.length,
                        (index) {
                          return InkWell(
                            onTap: () {
                              if (!state.isLoadingProduct) {
                                searchController.clear();
                                context.read<CategoryProductBloc>().add(
                                    GetProductByCategoryEvent(
                                        categoryTitle[index]));
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                height: 30,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: categoryTitle[index] ==
                                          state.selectedCategory
                                      ? AppColors.secondary
                                      : AppColors.background,
                                  border:
                                      Border.all(color: AppColors.secondary),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                    child: Text(
                                  categoryTitle[index],
                                  style: TextStyle(
                                      color: categoryTitle[index] ==
                                              state.selectedCategory
                                          ? AppColors.background
                                          : AppColors.secondary),
                                )),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            final state = context.read<CategoryProductBloc>().state;
            if (!state.isLoadingTitle) {
              setState(() {
                isCategoryScroll = !isCategoryScroll;
              });
            }
          },
          child: Container(
            color: Colors.black,
            width: 25,
            height: 55,
            child: Center(
              child: Icon(Icons.keyboard_arrow_down),
            ),
          ),
        )
      ],
    );
  }

  BlocBuilder listProduct(List<ProductData> products) {
    return BlocBuilder<CategoryProductBloc, CategoryProductState>(
      builder: (context, state) {
        if (state.isLoadingProduct) {
          return ProductListLoad();
        }
        if (state.isErrorProduct) {
          return Center(child: Text("Error, Please try again"));
        }
        if (state.products.isNotEmpty) {
          products = state.products;
          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ProductListWidget(products: products)
                      .animate()
                      .fadeIn()
                      .move()),
              SizedBox(height: 10),
              state.isLoadMore || state.hasNextPage
                  ? Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: AppColors.secondary,
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 10)
            ],
          );
        }
        return SizedBox();
      },
    );
  }
}
