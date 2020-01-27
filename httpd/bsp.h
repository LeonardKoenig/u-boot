#ifndef __BSP_H__
#define __BSP_H__

#define HWID                    "DB120AR9344-RT-101214-00"
#define HWCOUNTRYID             "00"//00:us/na, 01:others country
#define MAC_ID                  0x00, 0x63, 0x07, 0x08, 0x64, 0x09, 0x10, 0x00
#define MACADDR                0xbf7e0000
#define DIAGNOSTIC_LED          14 /*it is STATUS_LED for loader*/
#define DLINK_ROUTER_LED_DEFINE	1
#define BSP_SETUP
#define MTD_LOADER_NAME "u-boot"  // cgi firmware upgrade used

/*For GPIO Setting*/

#define USB_LED			11	//	=>	GPIO 11		=> Active Low
#define WIRELESS_LED_2		12	//	=>	GPIO 12		=> Active Low
#define WIRELESS_LED_1		13	//	=>	GPIO 13		=> Active Low
#define STATUS_LED		14	//	=>	(Amber)GPIO 14	=> Active Low
#define WPS_LED_GPIO		15	//	=>	GPIO 15		=> Active Low
#define INTERNET_LED_2		18	//	=>	(Blue)GPIO 18	=> Active Low
#define INTERNET_LED_1		19	//	=>	(Amber)GPIO 19	=> Active Low
#define SWITCH_CONTROL		20	// 	=> 	Enable Ethernet switch LED data on GPIO_20 (INTERNET_LED_2)
#define POWER_LED		22	//	=>	(Blue)GPIO 22	=> Active Low

#define WPS_PUSH_BUTTON_GPIO	16	// 	=>	GPIO 16		=> Active Low => need to set 0xb8040028 bit0
#define PUSH_BUTTON		17	//	=>	GPIO 17		=> Active Low
#define RESET_BUTTON		 17  // sw1, GPIO 17, Active High
#define GPIO_IS_ACTIVE_HIGH   0
#define GPIO_IS_ACTIVE_LOW    1
#define BUTTON_DOWN GPIO_IS_ACTIVE_HIGH

/*
#define LAN1_LED		14	//	=>	GPIO 14		=> Active Low	=> need to set 0xb8040028 bit0 and bit4
#define LAN2_LED		15	//	=>	GPIO 15		=> Active Low	=> need to set 0xb8040028 bit0 and bit5
#define LAN3_LED		16	//	=>	GPIO 16			=> Active Low	=> need to set 0xb8040028 bit0 and bit6
#define PUSH_VALUE		0
*/

#define WIRELESS_LED	0xff //no define	


/*For kernel or u-boot*/
//#define AR7161	0
//#define AR7240	0
//#define AR7241	0
#define AR9344	1
 
//#define AP81  0
//#define AP83  0
//#define AP94	0
//#define AP98  0
//#define AP99  0
#define DB120  1

//#define WPS_WSCCMD    //DB120 use WPATALK
 
/*
	Loader used to erase / write loader / linux / rootfs image
	Flash Partition Allocation for 16M
	Related Files:
		apps/sutil/project.h
		u-boot/include/db12x.h (CONFIG_BOOTARGS, CFG_FLASH_SECTOR_SIZE)

	7 cmdlinepart partitions found on MTD device ath-nor0
	Creating 7 MTD partitions on "ath-nor0":
	0x000000000000-0x000000010000 : "u-boot"
	0x000000010000-0x000000020000 : "nvram"
	0x000000020000-0x000000fb0000 : "linux"
	0x000000160000-0x000000fb0000 : "rootfs"
	0x000000fb0000-0x000000fe0000 : "LANG"
	0x000000fe0000-0x000000ff0000 : "MAC"
	0x000000ff0000-0x000001000000 : "ART"

	Type	Start Address	End Address		Size
	U-Boot		0x00000000		0x00010000		  64	kbytes
	nvram		0x00010000		0x00020000		  64	kbytes
linux+rootfs	0x00020000		0x00fb0000		15936	kbytes
	LANG		0x00fb0000		0x00fe0000		 192	kbytes
	MAC			0x00fe0000		0x00ff0000		  64	kbytes
	ART			0x00ff0000		0x01000000		  64	kbytes
*/
#define BACKUP_ERASE_START_SECTOR   0
#define BACKUP_ERASE_END_SECTOR     0x1 /* u-boot + nvram */
#define NORMAL_ERASE_START_SECTOR   0x2 /* sklp u-boot and nvram */
#define NORMAL_ERASE_END_SECTOR     0xfc /* linux + rootfs + LANG(language pack) */

#define BUFF_LOCATION 	 0x80200000 //used by u-boot/httpd


/*
s17 switch driver used
*/
#define MAC_WAN_PORT 5  // used for HW NAT port defined in switcd driver
#if defined(_ATHRS17_PHY_H) && defined(PROPRIETARY_SWITCH_DRIVER_INIT)
/*
Usage: Initialize switch driver in driver code instead of setting it in apps
Note:
    - _ATHRS17_PHY_H is defined in athrs17_phy.h, this amis to prevent un-related souce codes using these definitions
    - If project uses the same borad layout as below, you do not need to edit anything
      If not, depends on the port you used and function, you may need to edit following setting
      More detail please refer to s17 data sheet

      Reference Board   |  CPU  |  WAN  |  LAN  |  LAN  |  LAN  |  LAN  |  LAN  |
      DIR-825_C1        |  CPU  |  LAN  |  LAN  |  LAN  |  LAN  |  WAN  |  ---  |
      MAC PORT          |   0   |   1   |   2   |   3   |   4   |   5   |  ---  |
      Phy PORT          |  ---  |   0   |   1   |   2   |   3   |   4   |  ---  |

    - S17_GLOFW_CTRL1_REG_VALUE_DEFAULT
      Different used ports related registers:

    - IGMPSNOOPING:
       - S17_GLOFW_CTRL1_REG_VALUE, igmpsnooping need to initialize different port
       - S17_FRAME_ACK_CTL1_OFFSET, S17_FRAME_ACK_CTL0_OFFSET, igmpsnooping need to initialize different port

    - Recognize tag packet from CPU:
       - Each port u used, u need to initialize it

    - Insert PVID 1 / 2 to LAN / WAN ports
       - Each project may has diffent used ports, please refer to data sheet then adjust it
       - Adjust Lan / Wan ports, S17_P0VLAN_CTRL0_REG_VALUE ~ S17_P6VLAN_CTRL0_REG_VALUE

    - Egress tag packet to CPU and untagged packet to LAN port
       - Each project may has diffent used ports, please refer to data sheet then adjust it

    - Group ports  to  VID 1
       - Each project may has diffent used ports, please refer to data sheet then adjust it
       - S17_VTU_FUNC0_REG_VLAN_PVID1_VALUE, S17_VTU_FUNC0_REG_VLAN_PVID2_VALUE need to adjust
*/

#define S17_GLOFW_CTRL1_REG_VALUE              0x3F3F213F       // igmpsnooping releated,  0011 1111 0011 1111 0010 0001 0011 1111
#define S17_GLOFW_CTRL1_REG_VALUE_DEFAULT      0x007f7f7f       // S17_BROAD_DPALL | S17_MULTI_FLOOD_DPALL | S17_UNI_FLOOD_DPALL
                                                                //                                   0111 1111 0111 1111 0111 1111
#define S17_ARL_CTRL_REG_VALUE                 0x50f8002b       // igmpsnooping releated,  0101 0000 1111 1000 0000 0000 0010 1011
#define S17_FRAME_ACK_CTL1_OFFSET_VALUE        0x01060606       // igmpsnooping ,enable IGMP JOIN LEAVE on port 4 ~ 6,
                                                                //               enable IGMP v3/MLD V2, bit 24
                                                                //                              0001 0000 0110 0000 0110 0000 0110
#define S17_FRAME_ACK_CTL0_OFFSET_VALUE        0x06060600       // igmpsnooping releated, enable IGMP JOIN LEAVE on port 1 ~ 3
                                                                //                              0110 0000 0110 0000 0110 0000 0000
								// Notice: Don't enable port 0(CPU port), it will block IPv6 DAD packet
#define S17_P0PAD_MODE_REG_VALUE               0x07600000       // PORT0 PAD Mode
#define S17_P6PAD_MODE_REG_VALUE               0x01000000       // PORT6 PAD Mode
#define S17_P0STATUS_REG_VALUE                 0x7e             // PORT0_STATUS register
#define S17_P6STATUS_REG_VALUE                 0x7e             // PORT6_STATUS register

#define S17_GLOFW_CTRL0_REG_VALUE              0x000004f0       // value is provided by vendor
#define S17_P0LOOKUP_CTRL_REG_VALUE            0x0014017e       // value is provided by vendor
#define S17_P1LOOKUP_CTRL_REG_VALUE            0x0014017d       // value is provided by vendor
#define S17_P2LOOKUP_CTRL_REG_VALUE            0x0014017b       // value is provided by vendor
#define S17_P3LOOKUP_CTRL_REG_VALUE            0x00140177       // value is provided by vendor
#define S17_P4LOOKUP_CTRL_REG_VALUE            0x0014016f       // value is provided by vendor
#define S17_P5LOOKUP_CTRL_REG_VALUE            0x0014015f       // value is provided by vendor
#define S17_P6LOOKUP_CTRL_REG_VALUE            0x0014013f       // value is provided by vendor
#define VLAN_PVID1                             0x00010001
#define VLAN_PVID2                             0x00020001
#define S17_P0VLAN_CTRL0_REG_VALUE             VLAN_PVID1
#define S17_P1VLAN_CTRL0_REG_VALUE             VLAN_PVID1
#define S17_P2VLAN_CTRL0_REG_VALUE             VLAN_PVID1
#define S17_P3VLAN_CTRL0_REG_VALUE             VLAN_PVID1
#define S17_P4VLAN_CTRL0_REG_VALUE             VLAN_PVID1
#define S17_P6VLAN_CTRL0_REG_VALUE             VLAN_PVID1
#define S17_P5VLAN_CTRL0_REG_VALUE             VLAN_PVID2
#define S17_P0VLAN_CTRL1_REG_VALUE             0x00002040
#define S17_P1VLAN_CTRL1_REG_VALUE             0x00001040
#define S17_P2VLAN_CTRL1_REG_VALUE             0x00001040
#define S17_P3VLAN_CTRL1_REG_VALUE             0x00001040
#define S17_P4VLAN_CTRL1_REG_VALUE             0x00001040
#define S17_P5VLAN_CTRL1_REG_VALUE             0x00001040
#define S17_P6VLAN_CTRL1_REG_VALUE             0x00001040
#define S17_VTU_FUNC0_REG_VLAN_PVID1_VALUE     0x001bd560
#define S17_VTU_FUNC0_REG_VLAN_PVID2_VALUE     0x001b7fe0
#define S17_VTU_FUNC1_REG_VLAN_PVID1_VALUE     0x80010002
#define S17_VTU_FUNC1_REG_VLAN_PVID2_VALUE     0x80020002

#define S17_NORMALIZE_CONTROL0                 0X0200
#define S17_NORMALIZE_CONTROL0_VALUE           0x0000A076
#define S17_NORMALIZE_CONTROL1                 0X0204
#define S17_NORMALIZE_CONTROL1_VALUE           0x00000007
#define S17_PWS_REG_VALUE                      0xc1000000
#endif // end _ATHRS17_PHY_H

#endif //__BSP_H__
