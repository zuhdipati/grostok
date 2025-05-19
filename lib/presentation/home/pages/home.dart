import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grostok/bloc/product/get-product/product_bloc.dart';
import 'package:grostok/bloc/product/search-product/search_product_bloc.dart';
import 'package:grostok/core/const/app_assets.dart';
import 'package:grostok/core/const/app_colors.dart';
import 'package:grostok/core/routes/app_route.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:grostok/widgets/debouncer.dart';
import 'package:grostok/widgets/product_list_load.dart';
import 'package:grostok/widgets/product_list_widget.dart';

List strImg = [
  'https://media.gettyimages.com/id/1985271294/video/new-product-banner-template-on-the-abstract-pop-art-rotated-background-ultra-hd-4k-video.jpg?s=640x640&k=20&c=BpPxOYQSoeDJCLvUxhNA0f_SifCbRBkGVdHQGH1odI4=',
  'https://img.freepik.com/free-vector/cosmetic-bottles-advertising-beauty-skin-care-product-banner_33099-1765.jpg?semt=ais_hybrid&w=740',
  'https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/b530f7110494491.5feef8228f2b8.png',
  'https://as2.ftcdn.net/v2/jpg/02/07/25/49/1000_F_207254995_0pdVxbemGBmjeChzFPgRYQmF6TAjYqRO.jpg'
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  final debouncer = Debouncer(milliseconds: 100);
  int carouselIndex = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (searchController.text.length > 2) {
          final bloc = context.read<SearchProductBloc>();

          if (bloc.state is SearchProductLoaded) {
            final state = bloc.state as SearchProductLoaded;
            if (state.hasNextPage && !bloc.isLoadMore) {
              debouncer.run(
                () {
                  bloc.add(GetMoreSearchProductEvent(query: bloc.state.query));
                },
              );
            }
          }
        } else {
          final bloc = context.read<ProductBloc>();

          if (bloc.state is GetProductLoaded) {
            final state = bloc.state as GetProductLoaded;
            if (state.hasNextPage && !bloc.isLoadMore) {
              debouncer.run(
                () {
                  bloc.add(GetMoreProductEvent());
                },
              );
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              searchBar(),
              SizedBox(height: 15),
              searchController.text.length > 2
                  ? searchSection()
                  : Column(
                      children: [
                        carouselSlider(context),
                        SizedBox(height: 25),
                        newArrived(),
                        SizedBox(height: 20),
                        loadPagination(),
                      ],
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<SearchProductBloc, SearchProductState> searchSection() {
    return BlocBuilder<SearchProductBloc, SearchProductState>(
      builder: (context, state) {
        if (state is SearchProductLoading) {
          return ProductListLoad();
        }

        if (state is SearchProductError) {
          return Center(
            child: Text("Error, Please try again"),
          );
        }

        if (state is SearchProductLoaded) {
          List<ProductData> listDataSearch = state.productData;
          if (listDataSearch.isEmpty) {
            return SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                child: Center(child: Text("No Data")));
          } else {
            return Column(
              children: [
                ProductListWidget(
                  products: listDataSearch,
                ),
                SizedBox(height: 10),
                state.hasNextPage
                    ? CircularProgressIndicator.adaptive(
                        backgroundColor: AppColors.secondary)
                    : SizedBox()
              ],
            );
          }
        }

        return SizedBox();
      },
    );
  }

  Row searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SearchBar(
                controller: searchController,
                backgroundColor: WidgetStateProperty.all(AppColors.white),
                shadowColor: WidgetStatePropertyAll(AppColors.white),
                elevation: WidgetStatePropertyAll(1),
                padding: WidgetStatePropertyAll(EdgeInsets.only(left: 15)),
                hintText: 'Cari barang..',
                hintStyle: WidgetStatePropertyAll(
                    TextStyle(color: AppColors.secondary)),
                leading: SvgPicture.asset(
                  AppAssets.searchIcon,
                  colorFilter:
                      ColorFilter.mode(AppColors.secondary, BlendMode.srcIn),
                ),
                textStyle:
                    WidgetStateProperty.all(TextStyle(color: Colors.black)),
                onChanged: (value) {
                  if (searchController.text.length > 2) {
                    debouncer.run(
                      () => context
                          .read<SearchProductBloc>()
                          .add(GetSearchProductEvent(query: value)),
                    );
                  }
                  setState(() {});
                },
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(AppAssets.cartIcon),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    minRadius: 7,
                    backgroundColor: Colors.red,
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            AppAssets.csIcon,
          ),
        ),
      ],
    );
  }

  Column carouselSlider(BuildContext context) {
    return Column(children: [
      CarouselSlider.builder(
        itemCount: strImg.length,
        options: CarouselOptions(
          height: 130,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          enlargeCenterPage: true,
          enlargeFactor: 0.2,
          autoPlay: true,
          onPageChanged: (index, reason) {
            carouselIndex = index;
            setState(() {});
          },
        ),
        itemBuilder: (context, index, realIndex) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: CachedNetworkImage(
              imageUrl: strImg[index],
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        image: imageProvider)),
              ),
            ),
          );
        },
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          strImg.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                height: 5,
                width: 20,
                color: carouselIndex == index
                    ? AppColors.secondary
                    : AppColors.background,
              ),
            );
          },
        ),
      )
    ]);
  }

  // Row menuIcon() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       HomeMenuWidget(
  //         assetName: AppAssets.franchiseIcon,
  //         title: "Franchise",
  //       ),
  //       HomeMenuWidget(
  //         assetName: AppAssets.distributorIcon,
  //         title: "Distributor",
  //       ),
  //       HomeMenuWidget(
  //         assetName: AppAssets.grosirIcon,
  //         title: "Grosir",
  //       ),
  //       HomeMenuWidget(
  //         assetName: AppAssets.artikelIcon,
  //         title: "Artikel",
  //       ),
  //     ],
  //   );
  // }

  // Column specialForYou() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 15),
  //         child: Text(
  //           "Special For You",
  //           style: TextStyle(fontSize: 20),
  //         ),
  //       ),
  //       SizedBox(height: 10),
  //       Container(
  //         color: AppColors.background,
  //         child: SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  //             child: Row(
  //                 children: List.generate(
  //               5,
  //               (index) {
  //                 return Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 5),
  //                   child: Container(
  //                     height: 170,
  //                     width: 140,
  //                     decoration: BoxDecoration(
  //                         color: Colors.grey,
  //                         borderRadius: BorderRadius.circular(15)),
  //                   ),
  //                 );
  //               },
  //             )),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Padding newArrived() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Arrived",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          listCatalog()
        ],
      ),
    );
  }

  BlocConsumer<ProductBloc, ProductState> listCatalog() {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetProductLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(
                backgroundColor: AppColors.secondary),
          );
        } else if (state is GetProductError) {
          return Center(
            child: Text("Error Get Data"),
          );
        } else if (state is GetProductLoaded) {
          List<ProductData> products = state.productData;

          return ProductListWidget(products: products)
              .animate()
              .fadeIn()
              .move();
        }
        return Container();
      },
    );
  }

  BlocBuilder<ProductBloc, ProductState> loadPagination() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is GetProductLoaded) {
          return state.hasNextPage
              ? Center(
                  child: CircularProgressIndicator.adaptive(
                      backgroundColor: AppColors.secondary),
                )
              : SizedBox();
        }
        return SizedBox();
      },
    );
  }
}
