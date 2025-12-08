import { NextRequest, NextResponse } from 'next/server';

/**
 * GET /api/v1/ppt/openai/models/available
 * Fetches available OpenAI-compatible models
 */
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { url, api_key } = body;

    if (!url || !api_key) {
      return NextResponse.json(
        { error: 'URL and API key are required' },
        { status: 400 }
      );
    }

    // Call OpenAI-compatible API to list models
    const response = await fetch(`${url}/models`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${api_key}`,
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`Failed to fetch models: ${response.statusText}`);
    }

    const data = await response.json();
    const models = data.data?.map((model: any) => model.id) || [];

    return NextResponse.json(models);
  } catch (error: any) {
    console.error('Error fetching OpenAI models:', error);
    return NextResponse.json(
      { error: error.message || 'Failed to fetch models' },
      { status: 500 }
    );
  }
}
