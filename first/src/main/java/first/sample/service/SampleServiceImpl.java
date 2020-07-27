package first.sample.service;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import first.common.util.FileUtils;
import first.sample.dao.SampleDAO;


@Service("sampleService")
public class SampleServiceImpl implements SampleService //�������̽� ��ӽ� implements
{	//SampleSeriveImpl Ŭ���� �����ϴµ� SampleSerive
	Logger log = Logger.getLogger(this.getClass()); //�α� �ѹ� ����ְ�
	
	@Resource(name="fileUtils")
	private FileUtils fileUtils;
	
	@Resource(name="sampleDAO")
	private SampleDAO sampleDAO; //SampleDAO �������ְ�

	@Override  //implements�� ��� �޾����� @Override�� �� ��������(SampleService���� �����ѳ�)
	public Map<String, Object> selectBoardList(Map<String, Object> map) throws Exception {
		log.debug("-----client response FROM openBoardList.do  START-----");
		log.debug("[ code    :" + map.get("code"));
		log.debug("  keyword :" + map.get("keyword") +" ]");
		log.debug("-----client response FROM openBoardList.do  END-------");
		return sampleDAO.selectBoardList(map);
	}
	
	@Override
	public void insertBoard(Map<String, Object> map, HttpServletRequest request) throws Exception 
	{
		
		fn_toStringMap(map);
		
		sampleDAO.insertBoard(map);
		String parent_idx = (String)map.get("PARENT_IDX");
		if(parent_idx != null)
			return;
		
		List<Map<String, Object>> list = fileUtils.parseInsertFileInfo(map, request);
		for(int i=0,size=list.size();i<size;i++)
		{
			sampleDAO.insertFile(list.get(i));
		}
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;
		Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
		MultipartFile multipartFile = null;
		
		while(iterator.hasNext())
		{
			multipartFile = multipartHttpServletRequest.getFile(iterator.next());
			
			if(multipartFile.isEmpty() == false)
			{
				log.debug("--------------file start------------");
				log.debug("name :" + multipartFile.getName());
				log.debug("filename :" + multipartFile.getOriginalFilename());
				log.debug("size :" + multipartFile.getSize());
				log.debug("--------------file end--------------\n");
			}
		}
	}
	
	@Override
	public Map<String, Object> selectBoardDetail(Map<String, Object> map) throws Exception 
	{
		String code = (String) map.get("code");
		if(code != null && code.equals("next")) {
			map.remove("IDX");
			map.put("IDX", map.get("NEXT"));
		} else if(code != null && code.equals("pre")) {
			map.remove("IDX");
			map.put("IDX", map.get("PRE"));
		}
		
		sampleDAO.updateHitCnt(map);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		Map<String, Object> tempMap = sampleDAO.selectBoardDetail(map);
		List<Map<String, Object>> replyList = sampleDAO.selectBoardReplyList(map);
		List<Map<String, Object>> list = sampleDAO.selectFileList(map);
		
		resultMap.put("map", tempMap);
		resultMap.put("replyList", replyList);
		resultMap.put("list", list);
		
		
		return resultMap;
	}
	
	@Override
	public Map<String, Object> boardUpdate(Map<String, Object> map) throws Exception
	{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> tempMap = sampleDAO.boardUpdate(map);
		resultMap.put("map", tempMap);
		
		List<Map<String, Object>> list = sampleDAO.selectFileList(map);
		resultMap.put("list", list);
		
		return resultMap;
	}
	
	@Override
	public void updateBoard(Map<String, Object> map, HttpServletRequest request) throws Exception
	{
		sampleDAO.updateBoard(map);  //���� �۸� ����(������Ʈ)
		
		sampleDAO.deleteFileList(map);  // (DEL_GB = 'Y') �� ó���ϴ� �κ�
		List<Map<String, Object>> list = fileUtils.parseInsertFileInfo(map, request);
		Map<String, Object> tempMap = null;
		for(int i=0,size=list.size();i<size;i++)
		{
			tempMap = list.get(i);
			if(tempMap.get("IS_NEW").equals("Y"))
			{
				sampleDAO.insertFile(tempMap);
			}else{
				sampleDAO.updateFile(tempMap);
			}
		}
	}

	@Override
	public void deleteBoard(Map<String, Object> map) throws Exception {
		if((map.get("idxArray")) instanceof String) {
			String idx = (String)map.get("idxArray");
			map.remove("idxArray");
			map.put("IDX", idx);
		}
		sampleDAO.deleteBoard(map);
	}
	
	private void fn_toStringMap(Map<?,?> map){
		Iterator itr = map.keySet().iterator();
		System.out.println("============ MAP START =====================");
		while(itr.hasNext()) {
			Object key = itr.next();
			System.out.println("[ key : " +key + " , value :" + map.get(key) + " ]");
		}
		System.out.println("=============  MAP END  ====================");
	}
}
