import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/edit_store_detail_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/manage_product_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/role_and_permission_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/worker_list_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class ManageStoreScreen extends StatefulWidget {
  const ManageStoreScreen({super.key});

  @override
  State<ManageStoreScreen> createState() => _ManageStoreScreenState();
}

class _ManageStoreScreenState extends State<ManageStoreScreen>
    with GlobalVarMixin {
  final OwnerStoresController ownerStoresController =
  Get.isRegistered<OwnerStoresController>()
      ? Get.find()
      : Get.put(OwnerStoresController());

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      physics:
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height5SizedBox,
          _buildMenuItem(
            title: StringConstants.editStoreDetailsText,
            iconPath: ImageConstants.editstore,
            onTap: () async {
              print("editStoreDetailsText clicked");
              if (ownerStoresController.storeId.value.isEmpty ||
                  (permissionStoreList.isEmpty && !hasStoreAccess.value)) {
                Utility.showAlertMessage(
                    "Please wait, store data is loading...");
                return;
              }

              final storeId = ownerStoresController.storeId.value;
              final hasEditPermission = permissionStoreList.any((element) =>
              (element.storeId == storeId && element.isStoreOwner == true) ||
                  (element.storeId == storeId.toString() &&
                      element.controllers?.any((c) =>
                      c.controllerKey ==
                          PermissionKey.editStore.statusName) ==
                          true));

              if ((hasStoreAccess.value && permissionStoreList.isEmpty) ||
                  hasEditPermission) {
                Get.to(() => const EditStoreDetailScreen(),
                    id: pageIdApp.value)
                    ?.then((_) =>
                    ownerStoresController.apiGetParticularStore());
              } else {
                Utility.showAlertMessage(
                    AlertStringConstants.notAuthorizedToStoreText);
              }
            },
          ),
          _buildMenuItem(
            title: StringConstants.manageProductsText,
            iconPath: ImageConstants.manageproduct,
            onTap: () {
              Get.to(
                    () => MangeProductScreen(
                  storeLocation: ownerStoresController.storeLocation.value,
                  storeName: ownerStoresController.storeName.value,
                  productId: "",
                  storeId: ownerStoresController.storeId.value,
                ),
                id: pageIdApp.value,
              );
            },
          ),
          _buildMenuItem(
            title: StringConstants.rolesAndPermissionText,
            iconPath: ImageConstants.role,
            onTap: () {
              Get.to(
                    () => RoleAndPermissionScreen(
                  storeId: ownerStoresController.storeId.value,
                  storeName: ownerStoresController.storeName.value,
                ),
                id: pageIdApp.value,
              );
            },
          ),
          _buildMenuItem(
            title: StringConstants.manageWorkersText,
            iconPath: ImageConstants.worker,
            onTap: () {
              final canAccess = hasStoreAccess.value && permissionStoreList.isEmpty ||
                  permissionStoreList.any((element) =>
                  element.storeId == ownerStoresController.storeId.value &&
                      element.isStoreOwner == true ||
                      element.storeId ==
                          ownerStoresController.storeId.value.toString() &&
                          element.controllers?.any((ele) =>
                          ele.controllerKey ==
                              PermissionKey.viewStoreUsers.statusName) ==
                              true);

              if (canAccess) {
                Get.to(
                      () => WorkerListScreen(
                    storeId: ownerStoresController.storeId.value,
                    storeName: ownerStoresController.storeName.value,
                  ),
                  id: pageIdApp.value,
                );
              } else {
                Utility.showAlertMessage(
                    AlertStringConstants.notAuthorizedToStoreText);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Reusable menu item widget
  Widget _buildMenuItem({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 1),
                        ),
                        child: const CircleAvatar(
                          radius: 28.0,
                          backgroundImage: AssetImage(ImageConstants.blackcircle),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Image.asset(iconPath, scale: 3),
                    ],
                  ),
                  width10SizedBox,
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.blackLight,
                size: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
